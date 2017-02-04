[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$EventsToday = @()
$Office365creds = Get-AutomationPSCredential -Name 'reporting platanisiotis com'
$jsonPayload = (@{userName=$Office365creds.username;password=$Office365creds.GetNetworkCredential().password;} | convertto-json).tostring()
$cookie = (Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/Register" -Body $jsonPayload).RegistrationCookie
$jsonPayload = (@{lastCookie=$cookie;locale="en-US";preferredEventTypes=@(2)} | convertto-json).tostring()
$events = (Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/GetEvents" -Body $jsonPayload)
foreach ($event in $events.Events) 
{
    if ($event.LastUpdatedTime.dayofyear -eq (get-date).AddDays(-1).DayOfYear) {$EventsToday += $event}
}
foreach ($EventToday in $EventsToday)
{
    $requestBody = @{}
    $requestBody.body = "$($EventToday.Title.ToString())
        $(($EventToday.Messages.MessageText).Replace('“','').Replace('”',''))

        $($EventToday.ExternalLink.ToString())
        $($EventToday.Id.ToString())"
    $requestBody.group_id = "5524516"
    $requestBody = ConvertTo-Json $requestBody
    $headers = New-Object 'System.Collections.Generic.Dictionary[[String],[String]]'
    $headers.Add('Authorization', 'Bearer ' + $(Get-AutomationVariable -Name 'AP Bot Bearer String for Yammer'))
    $target = 'https://www.yammer.com/api/v1/messages.json'
    $response = Invoke-RestMethod $target -Headers $headers -Method POST -Body $requestBody -ContentType application/json
}