function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceName,

        [ValidateSet("Running","Stopped")]
		[System.String]
		$Servicestatus,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."
		
    $serviceExists = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    If ($serviceExists.status -eq $ServiceStatus) {
            Write-Verbose "Service status is correct"
           
        }Else {
            write-Verbose "Service status is not correct"
            
        }
	
    $returnValue = @{
		ServiceName = [System.String]$ServiceName
		Servicestatus = [System.String]$serviceExists.Status
		Ensure = [System.String]$Ensure
	}
    $returnValue
	
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceName,

		[ValidateSet("Running","Stopped")]
		[System.String]
		$Servicestatus,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    Write-verbose "Changing service status"
    If ($serviceStatus -eq "Running") {
        Start-Service -name $serviceName
    }Else {
        Stop-Service -name $ServiceName
    }

	#Include this line if the resource requires a system reboot.
	$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceName,

		[ValidateSet("Running","Stopped")]
		[System.String]
		$Servicestatus,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."
    $serviceExists = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

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



	<#
	$result = [System.Boolean]
	
	$result
	#>
}


Export-ModuleMember -Function *-TargetResource

