If (Test-Connection -ComputerName $RemoteComputers -Quiet)
{
     Invoke-Command -ComputerName $RemoteComputers -ScriptBlock {Get-ChildItem “C:\Program Files”}
}

function Disable-RdpRules {
    $rdpRules = Get-NetFirewallRule | ? {$_.DisplayName -eq "Remote Desktop"}
    foreach($rule in $rdpRules) {
        if($rule.Enabled -eq "True" -and $rule.Profile -eq "Domain,Private,Public") {
            try {
                Set-NetFirewallRule -Name $rule.Name -Enabled False
                Write-Output "Remote Desktop has been turned off."
            }
            catch {
                $Error
            }
        }
    
        else {
            Write-Output "Remote Desktop has already been disabled or does not have a Profile of All."
        }
    }
}

function Remove-UserPath {
    [CmdletBinding()]
    param(
        [String[]]
        $Names
    )
    foreach($name in $Names) {
        $test = Test-Path "C:\Users\$name"
        if($test -eq $true) {
            Remove-Item -Path "C:\Users\$name" -Recurse 
            Write-Output "Unwanted user path $name removed."
        }
        else {
            Write-Output "User path $name, does not exist."
        }
    }
    Get-ChildItem -Path "C:\Users"
}

Disable-RdpRules
Remove-UserPath -Names Eric,env
