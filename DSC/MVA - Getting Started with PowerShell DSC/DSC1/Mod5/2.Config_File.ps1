
configuration TestFile {

    Node s1 {

        File ZipFile {
            Ensure = "Present" 
            Type = "Directory“ # Default is “File”
            Force = $True
            Recurse = $True
            SourcePath = '\\dc\Downloads'
            DestinationPath = 'C:\Downloads'  # On S1 
        }
    }
}

TestFile -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -force
