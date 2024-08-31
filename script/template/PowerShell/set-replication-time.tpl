#
# Run on ${HOSTNAME}
#

Import-Module ActiveDirectory

Set-ADReplicationSiteLink -Identity "DEFAULTIPSITELINK" -ReplicationFrequencyInMinutes 15
