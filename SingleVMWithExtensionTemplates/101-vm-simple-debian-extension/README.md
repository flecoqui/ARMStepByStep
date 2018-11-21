# Very simple deployment of an Debian VM running Apache (port 80) 

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FSingleVMWithExtensionTemplates%2F101-vm-simple-debian-extension%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FSingleVMWithExtensionTemplates%2F101-vm-simple-debian-extension%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


This template allows you to deploy a simple Debian VM running Apache, using the latest patched version. This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
With Azure CLI you can deploy this VM with 2 command lines:

## CREATE RESOURCE GROUP:
**Azure CLI:** azure group create "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group create –n "ResourceGroupName" -l "RegionName"

For instance:

    azure group create simplevmrg eastus2

    az group create -n simplevmrg -l eastus2

## DEPLOY THE VM:
**Azure CLI:** azure group deployment create "ResourceGroupName" "DeploymentName"  -f azuredeploy.json -e azuredeploy.parameters.json*

**Azure CLI 2.0:** az group deployment create -g "ResourceGroupName" -n "DeploymentName" --template-file "templatefile.json" --parameters @"templatefile.parameter..json"  --verbose

For instance:

    azure group deployment create simplevmrg simplevmtest -f azuredeploy.json -e azuredeploy.parameters.json -vv

    az group deployment create -g simplevmrg -n simplevmtest --template-file azuredeploy.json --parameter @azuredeploy.parameters.json --verbose

## DELETE THE RESOURCE GROUP:
**Azure CLI:** azure group delete "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group delete -n "ResourceGroupName" "RegionName"

For instance:

    azure group delete simplevmrg eastus2
	
    az group delete -n simplevmrg 

