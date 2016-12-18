function Clear-Screen
{
    [Alias("x")]
    Param
    ()
    Set-Location \ 
    Clear-Host
}