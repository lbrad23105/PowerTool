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
        $logCompilation = New-Item -Path "C:\indicium\logs\log.txt" -ItemType File -Force
        foreach($log in $logs)
        {
            Write-Output "Compiling log list..."
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
    $log = "C:\indicium\logs\log.txt"
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
    $log = "C:\indicium\logs\log.txt"
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
    foreach($drive in $drives)
    {
        
    } 
}

function Invoke-LogWebPage
{
    
    $sourceFile = "C:\indicium\logs\log.txt"
    $targetFile = "C:\indicium\logs\LogView.html"
    Write-Output "Creating web page..."
    $file = Get-Content $sourceFile
    $fileLine = @()
    foreach ($line in $file) 
    {
        $myObject = New-Object -TypeName PSObject
        Add-Member -InputObject $myObject -Type NoteProperty -Name LogView -Value $line
        $fileLine += $myObject
    }

    $fileLine | ConvertTo-Html -title "Log View" -body "<H2>Log View</H2>" | Out-File $targetFile
    Invoke-Item -Path "C:\indicium\logs\LogView.html"
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
