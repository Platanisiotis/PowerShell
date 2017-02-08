[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
[int]$x = ([xml]$(wget ftp://ftp.bom.gov.au/anon/gen/fwo/IDN11060.xml -usebasicparsing)).product.forecast.area[2].("forecast-period")[1].element[3].("#text")
[int]$y = ([xml]$(wget ftp://ftp.bom.gov.au/anon/gen/fwo/IDN11060.xml -usebasicparsing)).product.forecast.area[2].("forecast-period")[1].element[2].("#text")
If ($x -ge "30") 
{
    $requestBody = @{}
    $requestBody.body = "Tomorrow will be between $y - $x degrees, so be sure to wear casual clothing and bring a spare set of business clothes if you will be seeing a client.
    
    The temperature will be checked every afternoon at 5PM."
    $requestBody.group_id = "9894045"
    $requestBody = ConvertTo-Json $requestBody
    $headers = New-Object 'System.Collections.Generic.Dictionary[[String],[String]]'
    $headers.Add('Authorization', 'Bearer ' + $(Get-AutomationVariable -Name 'AP Bot Bearer String for Yammer'))
    $target = 'https://www.yammer.com/api/v1/messages.json'
    $response = Invoke-RestMethod $target -Headers $headers -Method POST -Body $requestBody -ContentType application/json
}
if ($x -eq "29") 
{
    $requestBody = @{}
    $requestBody.body = "Tomorrow will be between $y - $x degrees, so be sure to wear business clothing. One degree off; unlucky!
    
    The temperature will be checked every afternoon at 5PM."
    $requestBody.group_id = "9894045"
    $requestBody = ConvertTo-Json $requestBody
    $headers = New-Object 'System.Collections.Generic.Dictionary[[String],[String]]'
    $headers.Add('Authorization', 'Bearer ' + $(Get-AutomationVariable -Name 'AP Bot Bearer String for Yammer'))
    $target = 'https://www.yammer.com/api/v1/messages.json'
    $response = Invoke-RestMethod $target -Headers $headers -Method POST -Body $requestBody -ContentType application/json
}