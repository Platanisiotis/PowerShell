#Requires -Version 2.0
function Clear-Screen
{
    [Alias("x")]
    Param
    ()
    Set-Location \ 
    Clear-Host
}