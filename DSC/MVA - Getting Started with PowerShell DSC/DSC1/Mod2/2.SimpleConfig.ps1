configuration ConfigName {
    Node $ComputerName {

        WindowsFeature IIS{
            Name = 'web-server'
            Ensure = 'Present'
        }
    }
}
$computername = 'S1','S2'
ConfigName -OutputPath c:\DSC\Config
