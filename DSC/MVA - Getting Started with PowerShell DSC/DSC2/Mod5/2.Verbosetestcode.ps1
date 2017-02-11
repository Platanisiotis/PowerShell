[CmdletBinding(SupportsShouldProcess=$true)]
[OutputType([System.Boolean])]
	param
	(
		#[parameter(Mandatory = $true)]
		[System.String]
		$ServiceName='bitsss',

		[ValidateSet("Running","Stopped")]
		[System.String]
		$Servicestatus='running',

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure='present'
	)

try{
Write-Verbose "Checking to see if servicename exists"
$serviceExists = Get-Service -Name $ServiceName -ErrorAction Stop

    if ($Ensure -eq 'Present') {   
        if($serviceExists -ne $null)
        {
            If ($serviceExists.status -eq $ServiceStatus) {
                Write-Verbose "Nothing to configure - Service exists and has correct status"
                Return $True
            }Else {
                Write-Verbose "Need to configure - Status is not correct"
                Return $False
            }
        } else {
            Write-Verbose "Nothing to configure - Service name does not exist"
            return $false
        }
    } Else {
        Write-Verbose "Nothing to configure - Ensure is Absent"
        return $False
    }
} Catch {
    $Global:ErrorMessage = $_
    Write-Verbose "Error occured running Test-TargetResource"
    Write-Verbose $ErrorMessage.Exception
    Write-debug $ErrorMessage
}

