
configuration TestArchive {

    Node s1 {

        Archive Unzip{
            Destination = 'C:\unzip'
            Path = 'c:\downloads\unzip.zip'
            Checksum = 'SHA-256'
            Validate = $true
            Force = $true
            Ensure = 'Present'
        }
    }
}

TestArchive -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -Force
