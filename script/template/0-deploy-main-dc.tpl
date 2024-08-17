#
# Run on DCPD01
#

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

$Password = ConvertTo-SecureString '${DSRM_PASSWORD}' -AsPlainText -Force

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
    -SafeModeAdministratorPassword $Password `
    -Force:$true
