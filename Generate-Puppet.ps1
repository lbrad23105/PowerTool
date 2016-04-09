<#
.Title
    Generate-Puppet
.Author
    Luke Brady
.Synopsis
   Generate Puppet code with snippet descriptors.
.EXAMPLE
   Generate-Puppet -Snippets file package service
#>
function Generate-Puppet
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Snippets defines the array that will generate the
        # specified code snippets.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String[]]$Snippets
    )
    # Runs the Build function.
    Build
}


$keyWords = @(
    "case", # Not yet supported.
    "class", # Not yet supported.
    "cron",
    "define", # Not yet supported.
    "else", 
    "exec",
    "file",
    "group",
    "host",
    "if",
    "node",
    "package",
    "service",
    "user",
    "yumrepo"
)

$file = 
"file { 'name':
    ensure => file,
    owner  => owner,
    group  => group,
    mode   => mode,
    source => 'puppet:///modules/class/file.txt';
}"

$service = 
"service { 'name':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    pattern    => 'name',
}"

$cron =
"cron { 'name':
  command => '/path/to/executable',
  # user => 'root',
  # hour => 1,
  # minute  => 0,
}"

$exec = 
"exec { 'name':
  command => '/bin/echo',
  # path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  # refreshonly => true,
}"

$group = 
"group { 'name':
  gid => 1,
}"

$Hosts = 
"host { 'name':
  ensure => 'present',
  name => 'name',
  ip => 'address',
}"

$package = 
"package { 'name':
  ensure => installed,
}"

$user = 
"user { 'name':
    comment => 'First Last',
    home => '/home/name',
    ensure => present,
    #shell => '/bin/bash',
    #uid => '501',
    #gid => '20',
    
}"

$yumrepo = 
"yumrepo { 'name':
    baseurl => '',
    descr => 'The name repository',
    enabled => '1',
    gpgcheck => '1',
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-name',
    mirrorlist => ''
}"

$if = 
"if test {
    # enter puppet code
}"

$else = 
"else {
    # enter puppet code
}"

function Build
{
    $pathTest = Test-Path -Path C:\Generate-Puppet
        if($pathTest -eq $false)
        {
            New-Item -Name Generate-Puppet -Path C:/ -ItemType Directory -Force
        }
        
        New-Item -Name generatedCode.pp -Path C:/Generate-Puppet/ -ItemType File -Force

    foreach($Snip in $Snippets)
    {
        if($Snip -eq "file" -or $Snip -eq "File")
        {
            Write-Output -InputObject $file >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "service" -or $Snip -eq "Service")
        {
            Write-Output -InputObject $service >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "cron" -or $Snip -eq "Cron")
        {
            Write-Output -InputObject $cron >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "exec" -or $Snip -eq "Exec")
        {
            Write-Output -InputObject $exec >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "host" -or $Snip -eq "Host")
        {
            Write-Output -InputObject $Hosts >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "package" -or $Snip -eq "Package")
        {
            Write-Output -InputObject $package >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "user" -or $Snip -eq "User")
        {
            Write-Output -InputObject $User >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "yumrepo" -or $Snip -eq "Yumrepo")
        {
            Write-Output -InputObject $yumrepo >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "if" -or $Snip -eq "If")
        {
            Write-Output -InputObject $if >> C:/Generate-Puppet/generatedCode.pp
        }

        if($Snip -eq "else" -or $Snip -eq "Else")
        {
            Write-Output -InputObject $else >> C:/Generate-Puppet/generatedCode.pp
        }
    }       
}
