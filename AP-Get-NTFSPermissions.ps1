<#
.Synopsis
   Collects NTFS Folder ACLs 
.DESCRIPTION
   A function used to collect Folder ALCs from NTFS filesystems, and export them to spreadsheets.
.EXAMPLE
   AP-Get-NTFSPermissions -LogLocation "c:\temp\logs\" -Paths "C:\temp"
   Collects all of the ACLs from c:\temp and exports the logs to c:\temp\logs\
.EXAMPLE
   AP-Get-NTFSPermissions -LogLocation "c:\temp\" -Paths ("C:\users\AP" | Get-ChildItem | select -ExpandProperty fullname) -Verbose
   Collects all of the ACLs from c:\users\AP and enumerates each 1st level child directory to create seperate spreadsheets.
   This is best used for targeting DFS namespaces, for example, as it will cycle through the top level shares of the namespace. 
.NOTES
   For any assistance with using this script or if you have any suggestions, please contact me! 
#>
Function AP-Get-NTFSPermissions{

    [cmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]

    Param(
        
        # Regex to assure the input is a UNC path that ends with a backslash. This is the only thing that doesn't work in Powershell v2
        # \\namespace\share\logdir\
        [Parameter(Mandatory=$true)]
        [validatePattern("^\\+.+\\$")]
        $LogLocation,

        # String that accepts multiple values for the paths you want to check the ACL of
        # \\namespace\share
        [Parameter(Mandatory=$true)]
        [string[]]
        $Paths,

        # The string that gets prefixed to the output file name
        # Default is the current date. 20150616
        [string]
        $Prefix = "$((get-date).ToString("yyyyMMdd"))"
    )

    Begin{
        $Error_FolderRecurseExceptions     = $null
    }

    Process {

        # Foreach path you specified in the $Paths parameter, do the following 
        foreach ($Path in $Paths) {

            $i                             = 0
            $TotalTimePerPath              = $null
            $Error_FolderRecurseExceptions = $null
            $FoldersTotalCount             = $null
            $TotalTime                     = $null
            $TimeValue                     = $null
            $CollectionLog                 = $null
            $ProcessedFolders              = $null


            # Create the default header for the spreadsheet and add it to memory
            $Measure_SpreadsheetHeaderNaming  = Measure-Command {
                $Header     = "Path,IdentityReference,AccessControlType,FileSystemRights,IsInherited"
            }
            Write-Verbose -Message "1/5 -Header content created for $Path"

            # Create the default file name for the spreadsheet and add it to memory
            $Measure_SpreadsheetNaming        = Measure-Command {
                $OutPutFile = ($LogLocation+$Prefix+"_"+$($($Path.ToString().Split("\"))[-1])+".csv")
            } 
            Write-Verbose -Message "2/5 - Filename created for $Path"

            # Create the spreadsheet with no content apart from the header, write to disk
            $Measure_CreateSpreadsheetHeader  = Measure-Command {
                Add-Content -Value $Header -Path $OutPutFile
            }
            Write-Verbose -Message "3/5 -Spreadsheet template for $Path created"

            # Collect all the recursed directories under the path specified. 
            # If errors are found add t9hem to the Error_FolderRecurseExceptions variable, although silently continue
            Write-Verbose -Message "4/5 -Collecting the folder structure for $Path"
            $Measure_CollectingFolders        = Measure-Command {
                $Folders     = Get-ChildItem $Path -recurse -ErrorAction SilentlyContinue -ErrorVariable +Error_FolderRecurseExceptions| where {$_.psiscontainer -eq $true}
            }
            [object[]]$Error_FolderRecurseExceptionsTotal += $Error_FolderRecurseExceptions
            Write-Verbose -Message "5/5 -Folder structure for $Path collected"

            # For each of the recursed directories that were processe without error, do the following
            $Measure_FolderACLCollection       = Measure-Command {
                
                foreach ($Folder in $Folders){
                    
                    if ($Folder.FullName -ne $Error_FolderRecurseExceptions.errorCategory_targetname) {

                        # Collecting the ACL under the Access property for the specific folder
                        # If errors are found add them to the Error_FolderRecurseExceptions variable, although silently continue
	                    $ACLs = get-acl $Folder.fullname -ErrorAction SilentlyContinue | ForEach-Object {$_.Access} -ErrorAction SilentlyContinue
                
                        # Foreach of those ACLs, enumerate the folder name, and the ACEs. 
                        # The ToString and replace was added to remove "," from file names as these would be made in to new cells for the spreadsheet
                        # If you have commas in your naming convention... Uninstall Windows.
                        Foreach ($ACL in $ACLs){
	                        $OutInfo = `
                                ($Folder.Fullname).Replace(",","") + "," + `
                                ($ACL.IdentityReference).ToString().Replace(",","")  + "," + `
                                ($ACL.AccessControlType).ToString().Replace(",","") + "," + `
                                ($ACL.FileSystemRights).ToString().Replace(",","") + "," + `
                                ($ACL.IsInherited).ToString().Replace(",","")

                        # After collecting the ACE add it to the spreadsheet
                        Add-Content -Value $OutInfo -Path $OutPutFile
	                }
                    
                    }
                # Write verbose output for the last folder enmurated, to keep track if the function is still working
                $($i++)
                Write-Verbose -Message "$i/$($Folders.count) - $($Folder.Fullname)"
                }
            }

            # Collect all the $Measure_* variables specified earlier and add them to a TotalTime variable
            foreach ($TimeValue in (Get-Variable measure_* | select -ExpandProperty value)) {
                $TotalTimePerPath += $TimeValue 
            }

            # Create a properties herestring with the values that make sense, this will be used for the clixml log
            $ObjectProperties = @{'Directory'       = $Path
                                  'Folders'         = $($Folders.Count)
                                  'ReadErrors'      = $Error_FolderRecurseExceptions.count
                                  'Spreadsheet'     = $OutPutFile
                                  'SpreadsheetSize' = $((Get-ChildItem $OutPutFile).Length)
                                  'Time'            = $($TotalTimePerPath)}

            # Create an object, and add those values to the object
            $Object                   = New-Object -TypeName PSObject -Property $ObjectProperties

            # Add each object to the collection
            [object[]]$Collection    += $Object

            # Collection log was made null at the start, so now contains the current Object
            $CollectionLog            = $Object

            # Removes the count of folder unable to process from folders processed
            $ProcessedFolders         = $($Folders.Count - $Error_FolderRecurseExceptions.count)

            # Format CollectionLogFormatted with the current object
            $CollectionLogFormatted   = $CollectionLog | Select @{Name="Directory";                 Expression={$_.Directory}},
                                                                @{Name="Folders Processed";         Expression={$ProcessedFolders}},
                                                                @{Name="Folders unable to Process"; Expression={$_.ReadErrors}},
                                                                @{Name="Spreadsheet Location";      Expression={$_.Spreadsheet}},
                                                                @{Name="Spreadsheet Size (kb)";     Expression={$_.SpreadsheetSize / 1kb -as [int]}},
                                                                @{Name="Time Taken";                Expression={$_.Time}}

            # Add the current data and time to the .log file
            (get-date).ToString("yyyy/MM/dd HH:mm:ss") | Out-File -FilePath ("$LogLocation"+"$Prefix.PermissionsLog.log") -Append

            # Add the formated object to a .log file which is just plain text
            $CollectionLogFormatted | Out-File -FilePath ("$LogLocation"+"$Prefix.PermissionsLog.log") -Append

            $FoldersTotalCount += $Folders.Count
            $TotalTime         += $TotalTimePerPath
        }
        # Add the content of the current object to the clixml
        $Collection | Export-Clixml -Path ("$LogLocation"+"$Prefix.PermissionsObjectLog.clixml")

        # Format the collection for user friendly reading. Use the clixml for more details 
        $CollectionFormatted = $Collection | Select @{Name="Directory";                 Expression={$_.Directory}},
                                                    @{Name="Folders Processed";         Expression={$ProcessedFolders}},
                                                    @{Name="Folders unable to Process"; Expression={$_.ReadErrors}},
                                                    @{Name="Spreadsheet Location";      Expression={$_.Spreadsheet}},
                                                    @{Name="Spreadsheet Size (kb)";     Expression={$_.SpreadsheetSize / 1kb -as [int]}},
                                                    @{Name="Time Taken";                Expression={$_.Time}}

        # Add the CollectionFormatted to the pipeline
        $CollectionFormatted

        # Create a properties herestring with the values that make sense
        $TotalsProps = @{'Total Folders Recursed'  = $FoldersTotalCount
                         'Total Time'              = $TotalTime}

        # Create an object, and add those values to the object
        $Totals      = New-Object -TypeName PSObject -Property $TotalsProps

        # Add Totals to the pipeline
        $Totals | Export-Clixml -Path ("$LogLocation"+"$Prefix.PermissionsTotalsLog.clixml")

        $Totals | Out-File -FilePath ("$LogLocation"+"$Prefix.PermissionsLog.log") -Append
    }

    End {
        
        # If errors were found and added to Error_FolderRecurseExceptions during the recurse process, do the following
        # This needs fixing as Error_FolderRecurseExceptionsTotal is always null due to the process
        if ($Error_FolderRecurseExceptionsTotal -ne $null) {

            # Create and empty array for the errors
            $Error_Collection = @()

            # Export the errors to a clixml file. This is the raw data of the error for debugging
            $Error_FolderRecurseExceptionsTotal | Export-Clixml -Path ("$LogLocation"+"$Prefix.PermissionsObjectErrorLog.clixml")
            Write-Warning -Message "Folder recurse errors found: Import-clixml $LogLocation$Prefix.PermissionsObjectErrorLog.clixml for further information"

            # For each one of the errors, collect the reason, folder and exception
            foreach ($FolderRecurseException in $Error_FolderRecurseExceptionsTotal) {
                $ErrorObjectProperties = @{'Reason'          = $FolderRecurseException.ErrorCategory_reason 
                                           'Folder'          = $FolderRecurseException.ErrorCategory_TargetName
                                           'Exception'       = $FolderRecurseException.Exception.Message}
            
                # Create an object, and add those values to the object
                $Error_Object      = New-Object -TypeName PSObject -Property $ErrorObjectProperties

                # Add each of the errors to a collection
                $Error_Collection += $Error_Object
            }

            # Add the Error_Collection to the pipeline
            $Error_Collection
        }
    }
}