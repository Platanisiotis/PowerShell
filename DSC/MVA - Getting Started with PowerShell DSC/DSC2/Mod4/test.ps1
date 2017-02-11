enum Ensure {

    Absent
    Present
}

[DscResource()]
class ClassService {
    
    [DscProperty(Key)]
    [string]$serviceName

    [DscProperty(Mandatory)]
    [Ensure] $Ensure

    [DscProperty(Mandatory)]
    [string] $Servicestatus


    [ClassService] Get() {

    $serviceExists = Get-Service -Name $this.serviceName -ErrorAction SilentlyContinue

    If ($ServiceExists.status -eq $this.ServiceStatus) {
            Write-Verbose "Service status is correct"
           
        }Else {
            write-Verbose "Service status is not correct"
            
        }
	return $this
    #$returnValue = @{
	#	ServiceName = [System.String]$this.ServiceName
	#	Servicestatus = [System.String]$serviceExists.Status
	#	Ensure = [System.String]$this.Ensure
	#}
    #return $returnValue

    }

    [void] Set() {
        
        Write-verbose "Changing service status"

        If ($this.serviceStatus -eq "Running") {
            Start-Service -name $this.serviceName
        }Else {
            Stop-Service -name $this.ServiceName
        }

    }

    [bool] Test() {
        $serviceExists = Get-Service -Name $this.ServiceName -ErrorAction SilentlyContinue

        if ($this.Ensure -eq 'Present') {   
            if($serviceExists -ne $null)
            {
                If ($serviceExists.status -eq $this.ServiceStatus) {
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



    }


}