REM Build Application
dotnet publish C:\git\flecoqui\ARMStepByStep\Step_5_ARMTemplateApps\cs\DeployARMTemplate\DeployARMTemplate --self-contained -c Release -r win-x64
pause
REM Create Service Principal Associated with the Application
REM AppId will be used as the ClientID parameter
REM Password will be used as the ClientSecret parameter
az ad sp create-for-rbac --name http://DeployARMTemplate --out json
pause
REM Displaying SubscriptionID and TenantID
az account show  --out json
pause
C:\git\flecoqui\ARMStepByStep\Step_5_ARMTemplateApps\cs\DeployARMTemplate\DeployARMTemplate\bin\Release\netcoreapp2.0\win-x64\publish\DeployARMTemplate.exe --subscriptionId <SubscriptionID> --tenantId <TenantID> --clientId <ClientID> --clientSecret <ClientSecret> --resourceGroup testarmdeployrg --region useast2 --templateFile ..\Tests\azuredeploy.json --parameterFile ..\Tests\azuredeploy.parameters.json
pause




