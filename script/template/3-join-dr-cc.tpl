#
# Run on CCPD51
#

$Password = ConvertTo-SecureString '${JOIN_PASSWORD}' -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ("${DOMAIN_NETBIOS_NAME}\${JOIN_USERNAME}", $Password)

Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter).Name -ServerAddresses ("${SERVER_ADDRESS}")
Add-Computer -DomainName "${DOMAIN_NAME}" -Credential $Credential -Restart
