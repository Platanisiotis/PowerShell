function Count-Words
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='File')]
        $FileName,

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1)]
        [int]$WordLength="1",

        $words
    )

    Begin
    {}
    Process
    {
        $File = Get-Content $FileName
        [int]$Found = $null
        [int]$WordCount = $null
        $Longest = “”
        $Dictionary = @{}
        [int]$LineCount = $null
        Write-Verbose “Reading file $FileName…” 

        $TotalLines = $File.Count
        Write-Verbose “$TotalLines lines read from the file.”

        $File | 
            foreach {
            $Line = $_
            $LineCount++
            Write-Progress -Activity “Processing words…” -PercentComplete ($LineCount*100/$TotalLines) 
            $Line.Split(” .,:;?!/()[]{}-“) | 
                foreach {
                $Word = $_.ToUpper()
                If ($Word[0] -ge ‘A’ -and $Word[0] -le “Z”)
                {
                    $WordCount++
                    If ($Word.Contains($SearchWord)) 
                    {
                        $Found++
                    }
                    If ($Word.Length -gt $Longest.Length)
                    {
                        $Longest = $Word
                    }
                    If ($Dictionary.ContainsKey($Word))
                    {
                        $Dictionary.$Word++
                    } 
                    else 
                    {
                        $Dictionary.Add($Word, 1)
                    }
                }
            } 
        }

        $DictWords = $Dictionary.Count
        Write-Progress -Activity “Processing words…” -Completed
        Write-Verbose “There were $WordCount total words in the text”
        Write-Verbose “There were $DictWords distinct words in the text”
        Write-Verbose “The longest word was $Longest”   
        
        if ($words -ne $null)
        {
            foreach ($i in $words)
            {
                $Dictionary.GetEnumerator() | ?{$_.name -like "$i"}
            }        
        }
        else
        {
            $Dictionary.GetEnumerator() | ?{$_.Name.Length -gt $WordLength} | Sort Value -Descending 
        }
    }
    End
    {}
}
