
# NX is hostname, 192.168.3.20

# Copy Resource module and show.
Copy-item -Path C:\Scripts\DSC1\Mod7\nx -Destination C:\Windows\System32\WindowsPowerShell\v1.0\Modules -Recurse -Force

Get-DscResource

# Get pre-req and build OMI Server
Start-Process -FilePath iexplore http://blogs.technet.com/b/privatecloud/archive/2014/05/19/powershell-dsc-for-linux-step-by-step.aspx
ise C:\scripts\dsc1\mod7\_NX_OMI.ps1

# Get configuration
ise C:\scripts\dsc1\mod7\WordPressConfig.ps1

# Apply config
ise C:\scripts\dsc1\mod7\WPDemoApply.ps1
