#
# Run on ${HOSTNAME}
#

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

$JoinPassword = ConvertTo-SecureString '${JOIN_PASSWORD}' -AsPlainText -Force
$JoinCredential = New-Object System.Management.Automation.PSCredential ("${DOMAIN_NETBIOS_NAME}\${JOIN_USERNAME}", $JoinPassword)

$DSRMPassword = ConvertTo-SecureString '${DSRM_PASSWORD}' -AsPlainText -Force

Install-ADDSDomainController `
    -NoGlobalCatalog:$false `
    -CreateDnsDelegation:$false `
    -Credential $JoinCredential `
    -CriticalReplicationOnly:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainName "${DOMAIN_NAME}" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SiteName "Default-First-Site-Name" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true `
    -SafeModeAdministratorPassword $DSRMPassword
