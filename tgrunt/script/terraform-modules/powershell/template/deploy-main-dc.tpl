#
# Run on ${HOSTNAME}
#

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

$DSRMPassword = ConvertTo-SecureString '${DSRM_PASSWORD}' -AsPlainText -Force

Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName "${DOMAIN_NAME}" `
    -DomainNetbiosName "${DOMAIN_NETBIOS_NAME}" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $DSRMPassword `
    -Force:$true
