Function Set-HKU
{
    New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
}
. Set-HKU | Out-Null -ErrorAction SilentlyContinue
