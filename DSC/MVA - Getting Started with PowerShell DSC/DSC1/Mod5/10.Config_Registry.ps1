
configuration TestRegistry {

    Node s1 {
        Registry CreateReg {
            Key = 'HKEY_Local_Machine\Software\DSCTest'
            ValueName = 'DSCTestGood'
            ValueType = 'string'
            ValueData = 'True'
        } 

    }
}

Testregistry -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -force
