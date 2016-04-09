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
