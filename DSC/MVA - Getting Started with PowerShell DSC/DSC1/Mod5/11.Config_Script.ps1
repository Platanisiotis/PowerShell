
configuration TestScript {

    Node s1 {
        Script TestScript {

            GetScript = {
                @{
                    GetScript = $GetScript
                    SetScript = $setScript
                    TestScript = $TestScript
                    Result = (Get-Service -name bits).status
                }           
            }

            SetScript = {
                Start-Service -name bits
            }

            TestScript = {
            
                $Status=(Get-service -name bits).status
                $Status -eq 'Running'
            }

        }
        
    }
}

Testscript -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -force
