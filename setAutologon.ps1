Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\" -Name AutoAdminLogon -value 1
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\" -Name DefaultPassword -value "Labview==="
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\" -Name DefaultUserName -value "labviewbuild"

# Get the IPv4 address of Azure Machine ( Internal IP )
$vmPrivateIP = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Auto").RDPAddressIPv4

# Get HEX representation from IP for setting computer name
$ipParts = $vmPrivateIP.Split('.')
$part1 = "{0:X2}" -f [int]$ipParts[0]
$part2 = "{0:X2}" -f [int]$ipParts[1]
$part3 = "{0:X2}" -f [int]$ipParts[2]
$part4 = "{0:X2}" -f [int]$ipParts[3]
$vmName = $part1 + $part2 + $part3 + $part4
           
Write-Host "Renaming the Computer and Restarting....."
# Trim names that are longer than 15 characters
$vmName = ("AZ-" + $vmName.Substring($vmName.Length - [System.Math]::Min(13, $vmName.Length),[System.Math]::Min(13, $vmName.Length)));
 
# Check the trimmed and cleaned VM name against the guest OS name
# If it is different, change the guest OS name and reboot
if ($env:computername -ne $vmName) {(gwmi win32_computersystem).Rename($vmName) }

# Forcing restart to make above changes. Default timer for system shutdown is 20 seconds, making it to 0.
shutdown -r -f -t 0