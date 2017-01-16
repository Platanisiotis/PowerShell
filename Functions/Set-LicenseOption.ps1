Function Set-LicenseOption
{
  $AccountSkuId = (Get-MsolAccountSku | ?{$_.AccountSkuID -like "*ENTERPRISEPACK"}).AccountSkuID
  #change it to All
  $LicensedUsers = (Get-MsolUser -All | Where { $_.IsLicensed -eq $true } | Select UserPrincipalName)

  ForEach ($User in $LicensedUsers) 
  {
      $Upn = $User.UserPrincipalName
      $AssignedLicenses = (Get-MsolUser -UserPrincipalName $Upn).Licenses
      $FLOW_O365_P2 = "Disabled";
      $POWERAPPS_O365_P2 = "Disabled";
      $TEAMS1 = "Disabled";
      $PROJECTWORKMANAGEMENT = "Disabled";
      $SWAY = "Disabled";
      $INTUNE_O365 = "Disabled";
      $YAMMER_ENTERPRISE = "Disabled";
      $RMS_S_ENTERPRISE = "Disabled";
      $OFFICESUBSCRIPTION = "Disabled";
      $MCOSTANDARD = "Disabled";
      $SHAREPOINTWAC = "Disabled";
      $SHAREPOINTENTERPRISE = "Disabled";
      $EXCHANGE_S_ENTERPRISE = "Disabled";

      ForEach ($License in $AssignedLicenses) 
      {
          If ($License.AccountSkuId -eq "$AccountSkuId") 
          {       
              ForEach ($ServiceStatus in $License.ServiceStatus) 
              {
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "FLOW_O365_P2" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $FLOW_O365_P2 = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "POWERAPPS_O365_P2" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $POWERAPPS_O365_P2 = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "TEAMS1" -and ($ServiceStatus.ProvisioningStatus -ne "Disabled" -or $ServiceStatus.ProvisioningStatus  -ne "PendingProvisioning") ) { $TEAMS1 = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "PROJECTWORKMANAGEMENT" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $PROJECTWORKMANAGEMENT = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "SWAY" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $SWAY = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "INTUNE_O365" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $INTUNE_O365 = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "YAMMER_ENTERPRISE" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $YAMMER_ENTERPRISE = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "RMS_S_ENTERPRISE" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $RMS_S_ENTERPRISE = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "OFFICESUBSCRIPTION" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $OFFICESUBSCRIPTION = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "MCOSTANDARD" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $MCOSTANDARD = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "SHAREPOINTWAC" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $SHAREPOINTWAC = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "SHAREPOINTENTERPRISE" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $SHAREPOINTENTERPRISE = "Enabled" }
                  If ($ServiceStatus.ServicePlan.ServiceName -eq "EXCHANGE_S_ENTERPRISE" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $EXCHANGE_S_ENTERPRISE = "Enabled" }
              }
              $DisabledOptions = @()
              If ($FLOW_O365_P2 -eq "Disabled") { $DisabledOptions += "FLOW_O365_P2" }
              If ($POWERAPPS_O365_P2 -eq "Disabled") { $DisabledOptions += "POWERAPPS_O365_P2" }
              #If ($TEAMS1 -eq "Disabled") { $DisabledOptions += "TEAMS1" }
              If ($SWAY -eq "Disabled") { $DisabledOptions += "SWAY" }
              If ($INTUNE_O365 -eq "Disabled") { $DisabledOptions += "INTUNE_O365" }
              If ($YAMMER_ENTERPRISE -eq "Disabled") { $DisabledOptions += "YAMMER_ENTERPRISE" }
              If ($RMS_S_ENTERPRISE -eq "Disabled") { $DisabledOptions += "RMS_S_ENTERPRISE" }
              If ($OFFICESUBSCRIPTION -eq "Disabled") { $DisabledOptions += "OFFICESUBSCRIPTION" }
              If ($MCOSTANDARD -eq "Disabled") { $DisabledOptions += "MCOSTANDARD" }
              If ($SHAREPOINTWAC -eq "Disabled") { $DisabledOptions += "SHAREPOINTWAC" }
              If ($SHAREPOINTENTERPRISE -eq "Disabled") { $DisabledOptions += "SHAREPOINTENTERPRISE" }
              If ($EXCHANGE_S_ENTERPRISE -eq "Disabled") { $DisabledOptions += "EXCHANGE_S_ENTERPRISE" }


              $LicenseOptions = New-MsolLicenseOptions -AccountSkuId $AccountSkuId -DisabledPlans TEAMS1
              Set-MsolUserLicense -User $Upn -LicenseOptions $LicenseOptions
          }
      }
  }
}
