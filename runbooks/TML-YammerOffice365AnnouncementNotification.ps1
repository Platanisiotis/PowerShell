$EventsToday = @()
$Office365creds = Get-AutomationPSCredential -Name 'reporting platanisiotis com'
$YammerCreds = Get-AutomationPSCredential -Name 'tml reporting'
$jsonPayload = (@{userName=$Office365creds.username;password=$Office365creds.GetNetworkCredential().password;} | convertto-json).tostring()
$cookie = (Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/Register" -Body $jsonPayload).RegistrationCookie
$jsonPayload = (@{lastCookie=$cookie;locale="en-US";preferredEventTypes=@(2)} | convertto-json).tostring()
$events = (Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/GetEvents" -Body $jsonPayload)
foreach ($event in $events.Events) 
{
    if ($event.LastUpdatedTime.dayofyear -eq (get-date).DayOfYear) {$EventsToday += $event}
}
foreach ($EventToday in $EventsToday)
{
    $EventFormated = $EventToday | 
        Select-Object ID, ExternalLink -ExpandProperty Messages -ErrorAction SilentlyContinue | 
            Format-List MessageText, ID, ExternalLink

    Send-MailMessage `
        -To "5524516+themissinglink.com.au@yammer.com" `
        -Cc "aplatanisiotis@themissinglink.com.au" `
        -Subject "$(($EventToday.Title).trim())" `
        -SmtpServer "smtp.office365.com" `
        -Credential $YammerCreds `
        -UseSsl:$true `
        -Port "587" `
        -Body "$($EventFormated | Out-String)AP Bot" `
        -From "svc_Email_Script_Account@themissinglink.com.au"
}
