<powershell>

# Assign a password to the specified user account
net user ${USERNAME} ${PASSWORD}

# Configure the system timezone to UTC -5 (SA Pacific Standard Time)
Set-TimeZone –Name "SA Pacific Standard Time"

# Turn off the firewall for all network profiles (Domain, Public, Private)
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

# Change the computer's name to the specified hostname and force a restart
Rename-Computer -NewName ${HOSTNAME} -Force -Restart

</powershell>