Function Set-HKU
{
    New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
}
