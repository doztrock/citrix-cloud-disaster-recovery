#
# Run on ${HOSTNAME}
#

Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter).Name -ServerAddresses ("${SERVER_ADDRESS_1}", "${SERVER_ADDRESS_2}")
Set-DnsClient -InterfaceAlias (Get-NetAdapter).Name -ConnectionSpecificSuffix "${DOMAIN_NAME}"
