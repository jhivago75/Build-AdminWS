# Original source https://github.com/SUBnet192/Scripts

# Call this script from a powershell command prompt using this command:
# Invoke-WebRequest -uri "https://raw.githubusercontent.com/jhivago75/Build-AdminWS/master/Build-AdminWSMDT.ps1"

# Preparation
Unregister-PSRepository -Name 'PSGallery'
Register-PSRepository -Default
Set-PSRepository PSGallery -InstallationPolicy Trusted
Set-ExecutionPolicy RemoteSigned -Force
if (-Not(Test-Path "C:\Scripts")) { New-Item -Path C:\ -Name Scripts -ItemType Directory }

# Update PowerShellGet
Install-PackageProvider -Name NuGet -Force
Install-Module PowerShellGet -Force
#Update-Module PowerShellGet

# Install RSAT
#Install-WindowsFeature -IncludeAllSubFeature RSAT
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online

# Install Powershell modules
Install-Module -Name VMware.PowerCLI
Install-Module -Name Testimo
Install-Module -Name DSInternals
Install-Module -Name PSPKI
Install-Module -Name PSColor -Force
Install-Module -Name ExchangeOnlineManagement
Find-Module -Name SUBNET192* | Install-Module

# Update the help files
Update-Help

# Chocolatey tools
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -uri "https://chocolatey.org/install.ps1" -UseBasicParsing | Invoke-Expression
Choco install chocolatey-gui -y

# Essential tools
Choco install openssh -y
Choco install ad-tidy-free -y

# Microsoft Tools
Choco install sysinternals -y
Choco install vscode-powershell -y

# SQL Related
Choco install sql-server-management-studio -y
Choco install dbatools -y

# Cloud - Azure / Office365
Choco install azure-cli -y
Choco install azcopy -y
Choco install msoid-cli -y

# Vmware related
Choco install rvtools -y
Choco install vmware-tools -y
Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCEIP $false -confirm:$false

# SpecOps GPUpdate
Invoke-WebRequest -Uri "https://download.specopssoft.com/Release/gpupdate/specopsgpupdatesetup.exe" -OutFile C:\Scripts\specops.exe
7z x C:\Scripts\specops.exe -oC:\Temp\
Start-Process -FilePath "$env:systemroot\system32\msiexec.exe" -ArgumentList '/i "C:\Temp\Products\SpecOpsGPUpdate\SpecopsGpupdate-x64.msi" /qb' -Wait
Remove-Item -Path C:\Temp -Recurse -Force
Remove-Item C:\Scripts\specops.exe

# Create default powershell profile for All Users / All Hosts
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhivago75/Build-AdminWS/master/profile.ps1" -Outfile $PROFILE.AllusersAllHosts
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhivago75/Build-AdminWS/master/profile.ps1" -Outfile "C:\Program Files\PowerShell\7\profile.ps1"

# Reboot to complete installation
#Restart-Computer