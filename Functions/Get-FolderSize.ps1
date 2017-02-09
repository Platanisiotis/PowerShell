function Get-FolderSize 
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [string[]]$Path,
        [ValidateSet("B", "KB", "MB", "GB", "TB")]
        [string]$SizeFormat="MB"
    )
    Begin 
    {}
    Process 
    {
        switch ($SizeFormat)
        {
            'B' 
            {
                $SizeLabel = 'Bytes'
                $SizeMath = '1B'
            }
            'KB' 
            {
                $SizeLabel = 'Bytes'
                $SizeMath = '1KB'
            }
            'MB' 
            {
                $SizeLabel = 'Mega Bytes'
                $SizeMath = '1MB'
            }
            'GB' 
            {
                $SizeLabel = 'Giga Bytes'
                $SizeMath = '1GB'
            }
            'TB' 
            {
                $SizeLabel = 'Terra Bytes'
                $SizeMath = '1TB'
            }
        }
        ForEach ($folder in $path) 
        {
            Write-Verbose "Measuring $folder"
            if (Test-Path -Path $folder) 
            {
                $params = @{
                    "Path" = $folder
                    "Recurse" = $true
                    "File" = $true
                }
                $measure = Get-ChildItem @params |
                    Measure-Object -Property Length -Sum
                [pscustomobject]@{
                    "Path" = $folder
                    "Files" = $measure.count
                    "$SizeLabel" = $($measure.sum / $SizeMath)
                }
            } 
            else 
            {
                Write-Warning "$folder - Path does not exist"
                [pscustomobject]@{
                    "Path" = $folder
                    "File" = 0
                    "$SizeLabel" = 0
                }
            }
        }
    }
    End 
    {}
}
