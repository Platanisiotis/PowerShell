#Requires -Version 3.0
# Issue with the last days and first days of the month missing
Function Get-Day 
{
    [CmdletBinding(SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([String])]
    Param (
        # Choose which task you would like to run.
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipeLinebyPropertyName=$true,
                    Position=0)]
        [ValidateSet("LastDayOfTheMonth","DaysInTheYear")]
        $Task,

        # Enter the name of the day of the week. eg. Monday The default day is Saturday, which will be used if no day is specified.
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                    Position=1)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")]
        [Alias("Day","D")]
        [string]
        $DayOfTheWeek="Saturday",

        # Enter day chronological number of the month you want to use. eg. June = 6, Janurary = 1
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                    Position=2)]
        [ValidateRange(1,12)]
        [int[]]
        $Month=(Get-Date).Month,

        # Enter the year you would like to use. Note: Allowed range is 2000 - 2100
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                    Position=3)]
        [ValidateRange(2000,2100)]
        [int[]]
        $Year=((Get-Date).Year)
    )
    Begin 
    {}
    Process 
    {
        $Years=@($Year)

        switch ($Task) 
        {

            LastDayOfTheMonth 
            {

                foreach ($y in $Years) 
                {
                    $MonthCollection=@($Month)

                    foreach ($m in $MonthCollection) 
                    {
                        If($m)
                        {
                            if($y) 
                            {
                                $LastDayOfMonth = (Get-Date -Year $y -Month $m -Day 1).AddMonths(1).AddDays(-1)
                            }
                            Else 
                            {
                                $LastDayOfMonth = (Get-Date -Year (Get-Date).Year -Month $m -Day 1).AddMonths(1).AddDays(-1)
                            }
                        }
                        Else 
                        {
                            $LastDayOfMonth = (Get-Date -Year (Get-Date).Year -Month (Get-Date).Month -Day 1).AddMonths(1).AddDays(-1)
                        }
                        $Answer = $Null
                        If($LastDayOfMonth.DayOfWeek -eq "$DayOfTheWeek") 
                        {
                            $Answer = $LastDayOfMonth
                        } 
                        Else 
                        {
                            While($Answer -eq $Null) 
                            {
                                $LastDayOfMonth = $LastDayOfMonth.AddDays(-1)
                                If($LastDayOfMonth.DayOfWeek -eq "$DayOfTheWeek") 
                                {
                                    $Answer = $LastDayOfMonth
                                }
                            }
                        }
                        Write-Verbose "Last $($Answer.DayOfWeek) of month $($Answer.Month) year $($Answer.Year)"
                        $Answer
                    }
                }
            }

            DaysInTheYear 
            {
                foreach ($y in $Years) 
                {
                    $MonthCollection=@($Month)

                    foreach ($m in $MonthCollection) 
                    {
                        $Behind = (Get-Date -Year $y -Month 1)
                        $Ahead = (Get-Date -Year $y -Month 12)

                        for ( $i = $Behind; $i -lt $Ahead ;$i=$i.AddDays(1) ) 
                        { 
                            foreach ($j in $m) 
                            {
                                $i | ?{$_.DayOfWeek -like "$DayOfTheWeek"} | ?{$_.Month -like "$j"}
                            }
                        }
                    }
                }
            }

        }
    }
}
