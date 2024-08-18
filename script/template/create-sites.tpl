#
# Run on ${HOSTNAME}
#

Import-Module ActiveDirectory

New-ADReplicationSite -Name "Main"
New-ADReplicationSite -Name "DR"

Move-ADDirectoryServer -Identity "DCPD01" -Site "Main"
Move-ADDirectoryServer -Identity "DCPD51" -Site "DR"

New-ADReplicationSubnet -Name "${MAIN_SUBNET}" -Site "Main"
New-ADReplicationSubnet -Name "${DR_SUBNET}" -Site "DR"

Remove-ADReplicationSite -Identity "Default-First-Site-Name" -Confirm:$false

New-ADReplicationSiteLink -Name "Main-DR" -SitesIncluded "Main", "DR" -Cost 100 -ReplicationFrequencyInMinutes 15
Remove-ADReplicationSiteLink -Identity "DEFAULTIPSITELINK" -Confirm:$false
