
configuration TestProcess {

    Node s1 {
        WindowsProcess CreateNotepad {
            Path = 'notepad.exe'
            Arguments = ''
        } 

        WindowsProcess CreatePaint {
            Path = 'mspaint.exe'
            Arguments = ''
        }
    }
}

TestProcess -OutputPath c:\DSC\Mod5Config
Start-DscConfiguration -computername s1 -Path c:\dsc\Mod5Config -Wait -Verbose -force
