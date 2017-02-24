Function New-CustomRegistryDrives
{
    $RegistryList = ("HKEY_CURRENT_CONFIG","HKCC"),("HKEY_USERS","HKU")
    foreach ($RegistryDrive in $RegistryList)
    {
        New-PSDrive -PSProvider Registry -Name $RegistryDrive[1] -Root $RegistryDrive[0]
    }
}
. New-CustomRegistryDrives | Out-Null -ErrorAction SilentlyContinue
