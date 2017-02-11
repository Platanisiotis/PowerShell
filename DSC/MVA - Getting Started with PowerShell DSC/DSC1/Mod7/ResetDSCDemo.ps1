$OFS=[Environment]::Newline

#Read Script elements from text files
$Get = Get-Content ".\reset\resetget.txt"
$Set = Get-Content ".\reset\resetset.txt"
$Test = Get-Content ".\reset\resettest.txt"

#Get WPConfig from file
$WPConfig  = Get-Content ".\scripts\WP-Config.txt"

#Define WordPress Server Configuration
Configuration InitialConfig
{
   
    #Import Linux DSC Module
    Import-DscResource -Module nx


    Node "157.59.132.154"{

        #Apache Configuration state
        nxScript InitialConfig
        {
           GetScript = "$Get"
           SetScript = "$Set"
           TestScript = "$Test"
        }
    }
 }

InitialConfig -outputpath:.\reset\

 $securePass=ConvertTo-SecureString -string "P@ssw0rd" -AsPlainText -Force
 $cred= New-Object System.Management.Automation.PSCredential "root", $SecurePass
 $opt = New-CimSessionOption -UseSsl:$true -SkipCACheck:$true -SkipCNCheck:$true -SkipRevocationCheck:$true
 $demo1=New-CimSession -Credential:$cred -ComputerName:157.59.132.154 -Port:5986 -Authentication:basic -SessionOption:$opt -OperationTimeoutSec:90
 

 Start-DscConfiguration -CimSession:$demo1 -Path:".\reset\" -wait -verbose -force