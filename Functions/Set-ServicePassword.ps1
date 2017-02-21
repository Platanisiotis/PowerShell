Function Set-ServicePassword 
{
    [cmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string[]]$computerName,

        [Parameter(Mandatory=$true)]
        [string[]]$ServiceName,

        [Parameter(Mandatory=$true)]
        [ValidateLength(8,30)]
        [string[]]$NewPassword,

        [Parameter()]
        [string]$ErrorLogFilePath = $($env:TEMP)
    )
    Begin 
    {}
    Process 
    {
        foreach ($computer in $computername) 
        {
            if (ComputerOnline $computerName) 
            {
                try 
                {
                    $services = Get-WmiObject -Class Win32_Service -Filter "name='$ServiceName'" -ComputerName $computer -ErrorAction Stop
                } 
                catch 
                {
                    $computer | Out-File $ErrorLogFilePath -Append
                }
                foreach ($Service in $services) 
                {
                    if ($PSCmdlet.ShouldProcess("$ServiceName at $computer")) 
                    {
                        $Service.change($null,$null,$null,$null,$null,$null,$null,$NewPassword)
                    }
                }
            }
        }
    }
    End 
    {}
}
