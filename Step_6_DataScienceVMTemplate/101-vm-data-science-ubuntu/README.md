# Deployment of a Ubuntu Data Science VM - Ubuntu version 14.04 - 16.04

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_6_DataScienceVMTemplate%2F101-vm-data-science-ubuntu%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_6_DataScienceVMTemplate%2F101-vm-data-science-ubuntu%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


This template allows you to deploy a simple Ubuntu Data Science VM, using the latest patched version. This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
With Azure CLI you can deploy this VM with 2 command lines:

## CREATE RESOURCE GROUP:
**Azure CLI:** azure group create "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group create �n "ResourceGroupName" -l "RegionName"

For instance:

    azure group create datasciencevmrg eastus2

    az group create -n datasciencevmrg -l eastus2


## ACCEPT THE TERMS FOR THE DEPLOYMENT OF THIS MARKET PLACE VM:

**Azure CLI 2.0:** az vm image accept-terms --urn microsoft-ads:linux-data-science-vm-ubuntu:linuxdsvmubuntu:latest

For instance:

	az vm image accept-terms --urn microsoft-ads:linux-data-science-vm-ubuntu:linuxdsvmubuntu:latest



## DEPLOY THE VM:
**Azure CLI:** azure group deployment create "ResourceGroupName" "DeploymentName"  -f azuredeploy.json -e azuredeploy.parameters.json*

**Azure CLI 2.0:** az group deployment create -g "ResourceGroupName" -n "DeploymentName" --template-file "templatefile.json" --parameters @"templatefile.parameter..json"  --verbose -o json

**Warning:** In order to use the Jupyter Notebook (http://VMIPAddress:8000/) use a Linux login in lower case. If the default login includes an upper-case character you'll get an "500: internal server" error.

For instance:

    azure group deployment create datasciencevmrg datasciencevmtest -f azuredeploy.json -e azuredeploy.parameters.json -vv

    az group deployment create -g datasciencevmrg -n datasciencevmtest --template-file azuredeploy.json --parameter @azuredeploy.parameters.json --verbose -o json

## DELETE THE RESOURCE GROUP:
**Azure CLI:** azure group delete "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group delete -n "ResourceGroupName" "RegionName"

For instance:

    azure group delete datasciencevmrg eastus2
	
    az group delete -n datasciencevmrg 