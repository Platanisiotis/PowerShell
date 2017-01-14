New-AzureRmResourceGroup -Name "VPN" -Location "australiaeast" -Verbose
New-AzureRmResourceGroupDeployment `
    -Name "Vvpndeployment" `
    -ResourceGroupName "VPN" `
    -TemplateUri https://github.com/Platanisiotis/PowerShell/blob/master/AzureRMTemplates/Point-to-Site%20VPN/azuredeploy.json `
    -TemplateParameterFile https://github.com/Platanisiotis/PowerShell/blob/master/AzureRMTemplates/Point-to-Site%20VPN/azuredeploy.parameters.json `
    -Verbose
