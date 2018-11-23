# Very simple deployment of an Windows Server VM 

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_1_SingleVMTemplates%2F101-vm-simple-windows%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_1_SingleVMTemplates%2F101-vm-simple-windows%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template allows you to deploy a simple Windows Server VM, using the latest patched version. This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
This template has been tested with the following Windows versions:
## 2008-R2-SP1
## 2012-Datacenter
## 2012-R2-Datacenter
## 2016-Datacenter
This template allows you to deploy a simple Windows Server VM running IIS and iPerf3, using the latest patched version. This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
With Azure CLI you can deploy this VM with 2 command lines:

## CREATE RESOURCE GROUP:
**Azure CLI:** azure group create "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group create –n "ResourceGroupName" -l "RegionName"

For instance:

    azure group create simplevmrg eastus2

    az group create -n simplevmrg -l eastus2

## DEPLOY THE VM:
**Azure CLI:** azure group deployment create "ResourceGroupName" "DeploymentName"  -f azuredeploy.json -e azuredeploy.parameters.json*

**Azure CLI 2.0:** az group deployment create -g "ResourceGroupName" -n "DeploymentName" --template-file "templatefile.json" --parameters @"templatefile.parameter..json"  --verbose -o json

For instance:

    azure group deployment create simplevmrg simplevmtest -f azuredeploy.json -e azuredeploy.parameters.json -vv

    az group deployment create -g simplevmrg -n simplevmtest --template-file azuredeploy.json --parameter @azuredeploy.parameters.json --verbose -o json

## DELETE THE RESOURCE GROUP:
**Azure CLI:** azure group delete "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group delete -n "ResourceGroupName" "RegionName"

For instance:

    azure group delete simplevmrg eastus2
	
    az group delete -n simplevmrg 


