<powershell>

# Set the timezone to UTC -5
Set-TimeZone –Name "SA Pacific Standard Time"

# Disable firewall on all the profiles
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

# Set the password
net user Administrator ${PASSWORD}

# Rename the computer
Rename-Computer -NewName ${HOSTNAME} -Force

# Reboot the computer
Restart-Computer

</powershell>