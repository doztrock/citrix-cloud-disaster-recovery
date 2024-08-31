#
# Run on ${HOSTNAME}
#

$JoinPassword = ConvertTo-SecureString '${JOIN_PASSWORD}' -AsPlainText -Force
$JoinCredential = New-Object System.Management.Automation.PSCredential ("${DOMAIN_NETBIOS_NAME}\${JOIN_USERNAME}", $JoinPassword)

Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter).Name -ServerAddresses ("${SERVER_ADDRESS_1}", "${SERVER_ADDRESS_2}")
Set-DnsClient -InterfaceAlias (Get-NetAdapter).Name -ConnectionSpecificSuffix "${DOMAIN_NAME}"

Add-Computer -DomainName "${DOMAIN_NAME}" -Credential $JoinCredential -Restart
