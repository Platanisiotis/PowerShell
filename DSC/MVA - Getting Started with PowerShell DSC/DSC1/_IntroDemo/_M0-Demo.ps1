# Just after introduction

# Quick Demo - Don't code - just show the idea - setting a service state.
ise C:\Scripts\dsc1\_IntroDemo\Fast_Config_Demo.ps1
ise C:\Scripts\DSC1\_IntroDemo\s3.mof
# Verify service is stopped and send new config
Get-service -name bits -ComputerName s3
Start-DscConfiguration -Path C:\Scripts\DSC1\_IntroDemo -ComputerName s3 -Wait -Verbose
# Test service state and config
Get-service -name bits -ComputerName s3
Test-DscConfiguration -CimSession s3
Get-DscConfiguration -CimSession s3
# Change service state
Invoke-Command -ComputerName s3 {Stop-service -name bits}
Get-service -name bits -ComputerName s3
Test-DscConfiguration -CimSession s3
# Reapply configuration
Start-DscConfiguration -ComputerName s3 -Wait -UseExisting
Test-DscConfiguration -CimSession s3
Get-service -name bits -ComputerName s3
