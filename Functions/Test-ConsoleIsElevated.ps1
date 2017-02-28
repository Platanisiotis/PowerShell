function Test-ConsoleIsElevated 
{
    $prp = new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
    $prp.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}