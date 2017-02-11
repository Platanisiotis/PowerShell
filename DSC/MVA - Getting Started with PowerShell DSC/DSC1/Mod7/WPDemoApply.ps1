 $securePass=ConvertTo-SecureString -string "P@ssw0rd" -AsPlainText -Force
 $cred= New-Object System.Management.Automation.PSCredential "root", $SecurePass
 $opt = New-CimSessionOption -UseSsl:$true -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true
 $demo1=New-CimSession -Credential:$cred -ComputerName 192.168.3.20 -Port:5986 -Authentication:basic -SessionOption:$opt -OperationTimeoutSec:90
 

 Start-DscConfiguration -CimSession:$demo1 -Path C:\DSCNX -wait -verbose # -force

 #Get-DSCConfiguration -CimSession:$demo1