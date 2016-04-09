# PowerTool

#### PowerTool currently includes:
- Invoke-Vmx
- Spatula
- Generate-Puppet

#### Invoke-Vmx Example:
This is all it takes to launch a VM.</br>
```powershell
Invoke-Vmx -Name $name -VMC $true 
```

#### Generate-Puppet Example:
This is all it takes to generate Puppet code templates.</br>
```powershell
Generate-Puppet -Snippets var,var,var,file,package,user,group 
```
This simple command generates the Puppet code below.
```puppet
$variable = ""
$variable = ""
$variable = ""
file { 'name':
    ensure => file,
    owner  => owner,
    group  => group,
    mode   => mode,
    source => 'puppet:///modules/class/file.txt';
}
package { 'name':
  ensure => installed,
}
user { 'name':
    comment => 'First Last',
    home => '/home/name',
    ensure => present,
    #shell => '/bin/bash',
    #uid => '501',
    #gid => '20',
    
}
group { 'name':
  gid => 1,
}
```
