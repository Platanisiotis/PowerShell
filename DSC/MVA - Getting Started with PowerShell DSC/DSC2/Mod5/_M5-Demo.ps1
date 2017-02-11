
# 1. Adding verbose and debug messages

ise C:\Scripts\DSC2\Mod5\1.MVAServiceverbose.psm1
# Add the following code to Test-Target - this has error checking and verbose
ise C:\scripts\DSC2\Mod5\2.Verbosetestcode.ps1

# 2. Adding help content

ise C:\Scripts\DSC2\Mod5\about_MVADemo.help.txt
# Create folder in module
New-Item -Path C:\scripts\DSC2\Mod5\MVADemo\en-US -ItemType directory -force
# copy to MVADemo
Copy-item -Path C:\Scripts\DSC2\Mod5\about_MVADemo.help.txt -Destination C:\Scripts\DSC2\Mod5\MVADemo\en-US
# Copy module
Copy-item C:\Scripts\DSC2\Mod5\MVADemo -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -Force
# Test
Get-Help about_M*

# 3. Handling computer Restarts

ise C:\Scripts\DSC2\Mod5\3.LCM_Reboot.ps1
ise C:\Scripts\DSC2\Mod5\5.MVAService.psm1

#Update MVADEMO module and copy to S1
Copy-Item -Path C:\Scripts\DSC2\Mod5\MVADemo -Destination '\\s1\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force

# add web-server to S1 
Invoke-command -ComputerName s1 {Install-WindowsFeature web-server}
# Create config
ise C:\Scripts\DSC2\Mod5\4.Config_Feature.ps1
# DONT use Windows-server-backup -- use web-server
