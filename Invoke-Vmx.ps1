<#
LB23-PSM1
Invoke-VMX is a way to automate Vagrant installations and management.
Written By Luke Brady (<lbrad23105@gmail.com>)
Tell Your Friends!!!
Dependencies: Chocolatey and Vagrant
Box Source: http://www.vagrantbox.es
Extremely extensible, add any Vagrant box from the URL above.
/#>

function Invoke-VMX
{
    [CmdletBinding()]
    Param
    (
        #Parameters include the name of the box you are spinning up, 
        #and the 
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Alias()]
        $Name,#Name your vagrant box
        $VMU, #Ubuntu/trusty installation.
        $VMC, #CentOS minimal installation.
        $VMF, #Fedora 22 installation.
        $VMD, #Debian installation.
        $VMPC,#Puppet Labs CentOS installation.
        $Other #User inputs desired distrobution.

    )
        #$VMU 
        #$VMC = "http://dl.dropbox.com/u/9227672/CentOS-6.0-x86_64-netboot-4.1.6.box"
        #$VMF = "http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vbox4210-nocm.box"

        #Install Chocolatey onto your system by running the command below. 
        #Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
        
        #Checks REGEX for Vagrant to determine if it needs to be downloaded or not.
        $checkChoc = (Get-ChildItem 'C:\' | Where-Object {[Regex]::IsMatch($_.Name.ToLower(),"chocolatey")})
        $output = (Get-ChildItem 'C:\HashiCorp\' | Where-Object {[Regex]::IsMatch($_.Name.ToLower(),"vagrant")})
        if($checkChoc.Name -cnotmatch "Chocolatey")
        {
          Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
        }
        
        else{
          Write-Output "Chocolatey is available."
          if($output.Name -Like "Vagrant")
          {
              #Lets the user know if Vagrant has been previously installed.
              Write-Output "Vagrant is installed on this machine."
          
          }
          
          else
          {
              #If Vagrant has never been installed, it is downloaded and installed,
              #and deployed from the Chocolatey repository.
              Choco install -y vagrant
              Write-Output "Vagrant has been installed....Creating Directories...."
              #Creates the Vagrant\VMX parent directories.
          }
          
          if($VMU -eq $true)
          {
              #Creates the Vagrant\VMX parent directories.
              mkdir -Force "C:\Vagrant\VMX\vmu-$Name"
              #Enters the directory to launch the Vagrant file.
              cd "C:\Vagrant\VMX\vmu-$Name"
              #Adds the newly created Vagrant Box, initializes and then boots it up.
              vagrant box add vmu-$Name "https://github.com/kraksoft/vagrant-box-ubuntu/releases/download/14.04/ubuntu-14.04-amd64.box";
              vagrant init vmu-$Name;
              vagrant up;
          
          }
          
          if($VMC -eq $true)
          {
              mkdir -Force "C:\Vagrant\VMX\vmc-$Name"
              cd "C:\Vagrant\VMX\vmc-$Name"
              vagrant box add vmc-$Name "http://dl.dropbox.com/u/9227672/CentOS-6.0-x86_64-netboot-4.1.6.box";
              vagrant init vmc-$Name;
              vagrant up;
          
          }
          
          
          if($VMF -eq $true)
          {
              #Creates the Vagrant\VMX parent directories.
              mkdir -Force "C:\Vagrant\VMX\vmf-$Name"
              #Enters the directory to launch the Vagrant file.
              cd "C:\Vagrant\VMX\vmf-$Name"
              #Adds the newly created Vagrant Box, initializes and then boots it up.
              vagrant box add vmf-$Name "http://puppet-vagrant-boxes.puppetlabs.com/fedora-18-x64-vbox4210-nocm.box"
              vagrant init vmf-$Name;
              vagrant up;
          
          }
          
          
          
          if($VMPC -eq $true)
          {
              #Creates the Vagrant\VMX parent directories.
              mkdir -Force "C:\Vagrant\VMX\vmpc-$Name"
              #Enters the directory to launch the Vagrant file.
              cd "C:\Vagrant\VMX\vmpc-$Name"
              #Adds the newly created Vagrant Box, initializes and then boots it up.
              vagrant box add vmpc-$Name "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
              vagrant init vmpc-$Name;
              vagrant up;
          
          }

     }
    
}


