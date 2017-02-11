configuration Backup {
    Node SMBComputers {

        WindowsFeature Backup{
            Name = 'Windows-Server-Backup'
            Ensure = 'Present'
        }
    }
}
Backup -OutputPath C:\DSCSMB
