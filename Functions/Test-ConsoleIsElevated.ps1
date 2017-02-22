function Test-ConsoleIsElevated 
{
    $prp = new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
    $prp.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}
$host.ui.RawUI.WindowTitle = "PowerShell - {0}\{1}{2}" -f $env:USERDOMAIN,$env:USERNAME,@(""," - as Admin")[(Test-ConsoleIsElevated)]
