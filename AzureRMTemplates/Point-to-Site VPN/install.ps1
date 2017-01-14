New-AzureRmResourceGroup -Name "VPN" -Location "australiaeast" -Verbose
New-AzureRmResourceGroupDeployment `
    -Name "Vvpndeployment" `
    -ResourceGroupName "VPN" `
    -TemplateUri https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/101-point-to-site/azuredeploy.json `
    -TemplateParameterFile .\azuredeploy.parameters.json `
    -Verbose
