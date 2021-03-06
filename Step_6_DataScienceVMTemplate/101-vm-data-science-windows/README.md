# Deployment of a Windows Data Science VM 

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_6_DataScienceVMTemplate%2F101-vm-data-science-windows%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_6_DataScienceVMTemplate%2F101-vm-data-science-windows%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template allows you to deploy a simple Windows Data Science VM, using the latest patched version. This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
This template has been tested with the following Windows versions:
## 2016-Datacenter
This template allows you to deploy a simple Windows 2016 Data Science VM , using the latest patched version. This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
With Azure CLI you can deploy this VM with 2 command lines:

## CREATE RESOURCE GROUP:
**Azure CLI:** azure group create "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group create �n "ResourceGroupName" -l "RegionName"

For instance:

    azure group create datasciencevmrg eastus2

    az group create -n datasciencevmrg -l eastus2

## ACCEPT THE TERMS FOR THE DEPLOYMENT OF THIS MARKET PLACE VM:

**Azure CLI 2.0:** az vm image accept-terms --urn microsoft-ads:windows-data-science-vm:windows2016:latest

For instance:

	az vm image accept-terms --urn microsoft-ads:windows-data-science-vm:windows2016:latest



## DEPLOY THE VM:
**Azure CLI:** azure group deployment create "ResourceGroupName" "DeploymentName"  -f azuredeploy.json -e azuredeploy.parameters.json*

**Azure CLI 2.0:** az group deployment create -g "ResourceGroupName" -n "DeploymentName" --template-file "templatefile.json" --parameters @"templatefile.parameter..json"  --verbose -o json

For instance:

    azure group deployment create datasciencevmrg datasciencevmtest -f azuredeploy.json -e azuredeploy.parameters.json -vv

	az group deployment create -g datasciencevmrg -n datasciencevmtest --template-file azuredeploy.json --parameter @azuredeploy.parameters.json --verbose -o json

## DELETE THE RESOURCE GROUP:
**Azure CLI:** azure group delete "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group delete -n "ResourceGroupName" "RegionName"

For instance:

    azure group delete datasciencevmrg eastus2
	
    az group delete -n datasciencevmrg 


