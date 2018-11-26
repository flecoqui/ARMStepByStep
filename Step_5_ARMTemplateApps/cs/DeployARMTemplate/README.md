# Sample .Net Core Application to deploy ARM (Azure Resource Manager) Templates
This project includes the source code to build a .Net Core application to programmatically deploy an ARM (Azure Resource Manager) template on Azure.

## How to build the Application 

This application is a .Net Core application running on:

**Windows:**  

    dotnet publish <DeployARMTemplate_Source_Code_Path> --self-contained -c Release -r win-x64

**Centos:**  

    dotnet publish <DeployARMTemplate_Source_Code_Path> --self-contained -c Release -r centos-x64

**Red Hat:**  

    dotnet publish <DeployARMTemplate_Source_Code_Path> --self-contained -c Release -r rhel-x64

**Ubuntu:**  

    dotnet publish <DeployARMTemplate_Source_Code_Path> --self-contained -c Release -r ubuntu-x64

**Debian:**  

    dotnet publish <DeployARMTemplate_Source_Code_Path> --self-contained -c Release -r debian-x64

**OSX:**  

    dotnet publish <DeployARMTemplate_Source_Code_Path> --self-contained -c Release -r osx-x64



## How to create an Azure AD application and an Service Principal that can access resources

In order to use the application with your Azure Subscription, you need to create an Azure AD application and an Service Principal to access resources associated with your subscription.
You can use the portal to create the Application, see [Use the portal to create an Azure AD application and service principal that can access resources](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal/). 

You can use Azure CLi v2.0 to create the Application.
The Azure CLI command below creates an Azure AD Application, the output parameters AppID and Password will be used by the application for the Azure authentication:      

    az ad sp create-for-rbac --name http://DeployARMTemplate --out json

The Azure CLI command below displays SubscriptionID and TenantID of your Azure Subscription.

    az account show  --out json


## How to use the Application 

When you launch the application you need set the following  parameters:

**SubscriptionID (--subscriptionId)**: The Azure subscription id associated with your Azure Susbcription

**TenantID (--tenantId)**: The Tenant id associated with your Azure Susbcription

**ClientID (--clientId)**: The Client id associated with your Azure AD Application

**ClientSecret (--clientSecret)**: The Client Secret associated with your Azure AD Application

**ResourceGroupName (--resourceGroup)**: The resource group name associated with your deployment

**Region (--region)**: The Azure Region associated with your deployment
List of possible region parameters: "uswest", "australiacentral2", "indiasouth", "indiawest", "koreasouth", "koreacentral", "chinanorth", "chinaeast", "australiacentral", "germanycentral", "governmentusvirginia", "governmentusiowa", "governmentusarizona", "governmentustexas", "governmentusdodeast", "governmentusdodcentral", "germanynortheast", "australiasoutheast", "indiacentral", "japanwest",  "uswest2", "uscentral", "useast", "useast2", "usnorthcentral", "australiaeast", "uswestcentral", "canadacentral", "canadaeast", "ussouthcentral", "europenorth", "europewest", "uksouth", "ukwest", "asiaeast",  "asiasoutheast", "japaneast", "brazilsouth".

**TemplateFile (--templateFile)**: The path of the Azure Resource Manager template file associated with your deployment 

**TemplateParameterFile (--parameterFile)**: The path of the Azure Resource Manager template parameter file  associated with your deployment

Syntax:

    DeployARMTemplate.exe --subscriptionId <SubscriptionID> --tenantId <TenantID> --clientId <ClientID> --clientSecret <ClientSecret> --resourceGroup <ResourceGroupName> --region <Region> --templateFile <TemplateFile> --parameterFile <TemplateParameterFile>

For instance:

    DeployARMTemplate.exe --subscriptionId <SubscriptionID> --tenantId <TenantID> --clientId <ClientID> --clientSecret <ClientSecret> --resourceGroup testarmdeployrg --region useast2 --templateFile ..\Tests\azuredeploy.json --parameterFile ..\Tests\azuredeploy.parameters.json

