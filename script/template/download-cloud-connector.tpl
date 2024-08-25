#
# Run on ${HOSTNAME}
#

Invoke-WebRequest -Uri 'https://downloads.cloud.com/${CUSTOMER_ID}/connector/cwcconnector.exe' -OutFile 'C:/cwcconnector.exe'
