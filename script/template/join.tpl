#
# Run on ${HOSTNAME}
#

$JoinPassword = ConvertTo-SecureString '${JOIN_PASSWORD}' -AsPlainText -Force
$JoinCredential = New-Object System.Management.Automation.PSCredential ("${DOMAIN_NETBIOS_NAME}\${JOIN_USERNAME}", $JoinPassword)

Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter).Name -ServerAddresses ("${SERVER_ADDRESS}")
Add-Computer -DomainName "${DOMAIN_NAME}" -Credential $JoinCredential -Restart
