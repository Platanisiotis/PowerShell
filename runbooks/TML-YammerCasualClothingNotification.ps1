[int]$x = ([xml]$(wget ftp://ftp.bom.gov.au/anon/gen/fwo/IDN11060.xml -usebasicparsing)).product.forecast.area[2].("forecast-period")[1].element[3].("#text")
[int]$y = ([xml]$(wget ftp://ftp.bom.gov.au/anon/gen/fwo/IDN11060.xml -usebasicparsing)).product.forecast.area[2].("forecast-period")[1].element[2].("#text")
If ($x -ge "30") 
{
    $Credential = Get-AutomationPSCredential -Name 'tml reporting'
    Send-MailMessage `
        -To "9894045+themissinglink.com.au@yammer.com" `
        -Cc "aplatanisiotis@themissinglink.com.au" `
        -Subject "Tomorrow will be between $y - $x degrees, so be sure to wear casual clothing and bring a spare set of business clothes if you will be seeing a client. The temperature will be checked every afternoon at 5PM. AP Bot" `
        -SmtpServer "smtp.office365.com" `
        -Credential $Credential `
        -UseSsl `
        -Port "587" `
        -Body "/AP Bot" `
        -From "svc_Email_Script_Account@themissinglink.com.au" `
        -BodyAsHtml
}