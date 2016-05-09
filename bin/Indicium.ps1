<#
Indicium
Written By: Luke Brady
#>
function Invoke-SystemSetup
{
    if(Test-Path -Path "C:\indicium")
    {
        Write-Output "Indicium has started..."
        Main
    }
    else
    {
        New-Item -Path "C:\indicium\" -ItemType Directory
        New-Item -Path "C:\indicium\logs\" -ItemType Directory
        Write-Output "Indicium has started..."
        Main
    }
}

function Filter-Logs
{
    $logDirectory = "C:\Windows\System32\winevt\Logs\"
    Write-Output "Fetching logs..."
    $logs = Get-Item -Path $logDirectory\*
    if(Test-Path $logDirectory)
    {
        $logCompilation = New-Item -Path "C:\logs.txt" -ItemType File -Force
        foreach($log in $logs)
        {
            Write-Output "Compiling Log List..."
            $logInformation = Get-WinEvent -Path $log
            $logInformation >> $logCompilation
            if($Error)
            {
                break
            }
        }
    }

    else
    {
        Filter-Logs
    }

}

function Parse-Information
{
    $information = 0
    $log = "C:\Users\lbrad23105\Desktop\logs.txt"
    $informationParse = Select-String Information -Path $log
    foreach($info in $informationParse)
    {
        $information++
    }
    return $information
}

function Parse-Errors
{
    $errors = 0
    $log = "C:\logs.txt"
    $errorParse = Select-String Error -Path $log
    foreach($err in $errorParse)
    {
        $errors++
    }
    return $errors
}

function Parse-LogFile
{
    Write-Host "Information: "; Parse-Information
    Write-Host "Errors: "; Parse-Errors
}

function Save-DriveState
{
    $date = Get-Date
    $driveState = Get-PSDrive | Where-Object {$_.Free -gt 0}
    $toGiga = $driveState.Free/1024/1024/1024
    $write = "$date $toGiga"
    New-Item -Path C:\indicium\logs\ -Name DriveState.txt -ItemType File -Force -Value $write
    Get-Content C:\indicium\logs\
}

function Get-DriveState
{
    $date = Get-Date
    $drives = Get-PSDrive | Where-Object {$_.Free -gt 0}
    foreach($drive in $drives)
    {
        
    } 
}

function Invoke-LogWebPage
{
    
    $sourceFile = "C:\logs.txt"
    $targetFile = "C:\LogView.html"
    Write-Output "Creating Web Page..."
    $file = Get-Content $sourceFile
    $fileLine = @()
    foreach ($line in $file) 
    {
        $myObject = New-Object -TypeName PSObject
        Add-Member -InputObject $myObject -Type NoteProperty -Name LogView -Value $line
        $fileLine += $myObject
    }

    $fileLine | ConvertTo-Html -title "Log View" -body "<H2>Log View</H2>" | Out-File $targetFile
    Invoke-Item -Path C:\LogView.html
}

function Main
{
    try
    {
        Filter-Logs
    }

    catch
    {
        "Error Caught $($Error[0])"
    }

    finally
    {
        Invoke-LogWebPage
        Write-Output "Done!"
    }
    
}

Invoke-SystemSetup
