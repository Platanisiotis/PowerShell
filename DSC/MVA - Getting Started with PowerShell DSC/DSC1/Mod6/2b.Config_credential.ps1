Configuration DirTest {
    param (
        [pscredential]$credential
    )
    Node S1 {
        File DirTest1 {
            DestinationPath = 'c:\DirTest'
            Type = 'Directory'
            Ensure = 'Present'
            Credential = $Credential
        }
    }
}
Dirtest -Credential (Get-Credential) -ConfigurationData C:\Scripts\DSC1\Mod6\2b.config_data.psd1 -OutputPath c:\DSCSecure

# Send to computers LCM
Start-DscConfiguration -ComputerName s1 -Path C:\DSCSecure –Verbose




