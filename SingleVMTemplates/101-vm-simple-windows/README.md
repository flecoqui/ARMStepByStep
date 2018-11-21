# Very simple deployment of an Windows Server VM running IIS (port 80) and iperf3 (port 5201)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2Fazure%2Fmaster%2Fazure-quickstart-templates%2F101-vm-simple-windows-iperf%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2Fazure%2Fmaster%2Fazure-quickstart-templates%2F101-vm-simple-windows-iperf%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


This template allows you to deploy a simple Windows Server VM running IIS and iPerf3, using the latest patched version. This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
This template has been tested with the following Windows versions:
## 2008-R2-SP1
## 2012-Datacenter
## 2012-R2-Datacenter
## 2016-Datacenter
This template allows you to deploy a simple Windows Server VM running IIS and iPerf3, using the latest patched version. This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
With Azure CLI you can deploy this VM with 2 command lines:

## CREATE RESOURCE GROUP:
azure group create "ResourceGroupName" "DataCenterName"

For instance:

    azure group create iperfgrpeu2 eastus2

## DEPLOY THE VM:
azure group deployment create "ResourceGroupName" "DeploymentName"  -f azuredeploy.json -e azuredeploy.parameters.json

For instance:

    azure group deployment create iperfgrpeu2 depiperftest -f azuredeploy.json -e azuredeploy.parameters.json -vv

## DELETE THE RESOURCE GROUP:
azure group delete "ResourceGroupName" "DataCenterName"

For instance:

    azure group delete iperfgrpeu2 eastus2
