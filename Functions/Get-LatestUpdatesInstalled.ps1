<# 
#> # Progress - No error checking
Function Get-LatestUpdatesInstalled
{

##########
# [char]0x0028 = (
# [char]0x0029 = )
# [char]0x0020 = <space>

    [cmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([int])]
    Param(
        [Parameter(Mandatory=$false,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        [string[]]$ComputerName = "localhost",

        [Parameter(Mandatory=$false, 
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true, 
                    ValueFromRemainingArguments=$false, 
                    Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("console", "window", "browser","csv")]
        [Alias("o")] 
        $OutPut = "Console",

        [Parameter(Mandatory=$false, 
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true, 
                    ValueFromRemainingArguments=$false, 
                    Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("true", "false")]
        [Alias("d")] 
        [switch]
        $detailed = $false
    )

    Begin
    {}
    Process
    {
        foreach ($Computer in $ComputerName)
        {
            $Session = New-Object -ComObject "Microsoft.Update.Session"
            $Searcher = $Session.CreateUpdateSearcher()
            $historyCount = $Searcher.GetTotalHistoryCount()
            $TotalHistory = ($Searcher.QueryHistory(0, $historyCount) |
                Select-Object `
                Title, `
                Description, `
                Date, `
                @{name="Operation"; expression={switch($_.operation) { 1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}}`
                ,@{name="ComputerName"; expression={$Computer}} )
            $LastUpdateDate = ($TotalHistory[0].Date.ToShortDateString())
            $LatestUpdatesInstalled = ($TotalHistory | ? {$_.date.ToShortDateString() -eq $LastUpdateDate})
            $LatestUpdatesInstalledSorted = $LatestUpdatesInstalled | select -Property ComputerName, Date, Operation, Title, Description
            
            Switch ($detailed)
            {

                "true"
                {
                    $processed = $LatestUpdatesInstalledSorted 
                }

                "false"
                {
                    $processed = ((($LatestUpdatesInstalledSorted.title.split([char]0x0028) | ?{$_ -like "KB*"}).TrimEnd([char]0x0029)).TrimStart("KB"))
                }
            }

            Switch ($OutPut)
            {

                "console"
                {
                    $processed 
                }

                "window"
                {
                    $processed | Out-GridView
                }

                "browser"
                {
                    (($LatestUpdatesInstalled.title.split([char]0x0028) | ?{$_ -like "KB*"}).TrimEnd([char]0x0029)).TrimStart("KB") | % `
                    { 
                        $ie = New-Object -ComObject InternetExplorer.Application
                        $ie.Navigate2("https://support.microsoft.com/en-us/kb/$_")
                        $ie.Visible = $true
                    }
                }

                "csv"
                {
                    $file = ("$ENV:SystemDrive\windows\temp\LatestInstallUpdates-$(Get-Date -Format yyy-MM-dd).csv")
                    $processed | Export-Csv -Path "$file"
                    explorer $file
                }
            }
        }
    }
    End
    {}
}
