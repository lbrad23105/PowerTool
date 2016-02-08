# Spatula - A simple script for automating chef bootstrapping.
# Luke Brady 2016

# Spatula - A simple script for automating chef bootstrapping.
# Luke Brady 2016

function Spatula
{
    Write-Host -ForegroundColor Yellow "Spatula v.1.0.0"
    $Setup = Read-Host 'First time setup?[$false]'
    $HOSTNAME = Read-Host "Hostname"
    $ADDRESS = Read-Host "Node-IP"
    $DOMAIN = Read-Host "Domain"
    $USER = Read-Host "Username"
    $PASSWORD = Read-Host "Password" -AsSecureString
    $NODENAME = Read-Host "Node-Name"
    [string[]]$COOKBOOKS = Read-Host "Cookbooks"
    $IncludeCookbookDownload = Read-Host 'Would you like to download a cookbook(s)?[$false]'
    if($IncludeCookbookDownload -eq $true)
    {
        [string[]]$CookbookDownload = Read-Host "Cookbooks to Download"
        knife cookbook site download $CookbookDownload
        tar -zxvf *$CookbookDownload*.tar* -C C:\Chef\cookbooks
        Remove-Item *$CookbookDownload*.tar*
        knife cookbook upload $CookbookDownload
    }
   if($Setup -eq $true)
   {
    if(Test-Path C:\Chef){}
    else
    {
     New-Item -Path C:\Chef\ -Force -ItemType Directory 
    }

    if(Test-Path C:\Chef\.chef)
    {}
    else
    {
     New-Item -Path C:\Chef\.chef -Force -ItemType Directory 
    }

    if(Test-Path C:\Chef\cookbooks)
    {}
    else
    {
     New-Item -Path C:\Chef\cookbooks -Force -ItemType Directory 
    }
     Set-Location -Path C:\Chef\

     $CERT = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $HOSTNAME
     winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
     New-Item -Address * -Force -Path wsman:\localhost\listener -Port 5986 -HostName ($CERT.subject -split '=')[1] -Transport https -CertificateThumbPrint $CERT.Thumbprint

     Set-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB 1024
     Set-Item WSMan:\localhost\MaxTimeoutms 1800000

     netsh advfirewall firewall add rule name="WinRM-HTTPS" dir=in localport=5986 protocol=TCP action=allow
     netsh advfirewall firewall set rule name="File and Printer Sharing (Echo Request - ICMPv4-In)" new enable=yes

     Test-NetConnection $HOSTNAME -Port 5986
    }
    else
    {
        knife bootstrap windows winrm $ADDRESS --winrm-user "$DOMAIN\$USER" --winrm-password $PASSWORD --node-name $NODENAME --run-list "recipe[$COOKBOOKS]" --winrm-transport ssl --winrm-ssl-verify-mode verify_none
        knife node show $NODENAME
    }
}
Spatula
