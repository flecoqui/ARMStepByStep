# Deployment of a VM (Linux or Windows) running Apache or IIS (port 80) 

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_3_SingleVMUniversalTemplate%2F101-vm-simple-universal%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_3_SingleVMUniversalTemplate%2F101-vm-simple-universal%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


This template allows you to deploy a simple VM running: </p>
#### Debian: Apache ,
#### Ubuntu: Apache, 
#### Centos: Apache, 
#### Red Hat: Apache,
#### Windows Server 2016: IIS,
#### Nano Server 2016: IIS
This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.
With Azure CLI you can deploy this VM with 2 command lines:


![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_3_SingleVMUniversalTemplate/101-vm-simple-universal/Docs/1-architecture.png)



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


Beyond login/password, the input parameters are :</p>
configurationSize (Small: F1 and 128 GB data disk, Medium: F2 and 256 GB data disk, Large: F4 and 512 GB data disk, XLarge: F4 and 1024 GB data disk) : 

    "configurationSize": {
      "type": "string",
      "defaultValue": "Small",
      "allowedValues": [
        "Small",
        "Medium",
        "Large",
        "XLarge"
      ],
      "metadata": {
        "description": "Configuration Size: VM Size + Disk Size"
      }
    }

configurationOS (debian, ubuntu, centos, redhat, nano server 2016, windows server 2016): 

    "configurationOS": {
      "type": "string",
      "defaultValue": "debian",
      "allowedValues": [
        "debian",
        "ubuntu",
        "centos",
        "redhat",
        "nanoserver2016",
        "windowsserver2016"
      ],
      "metadata": {
        "description": "The Operating System to be installed on the VM. Default value debian. Allowed values: debian,ubuntu,centos,redhat,nanoserver2016,windowsserver2016"
      }
    },



## TEST THE VM:
Once the VM has been deployed, you can open the Web page hosted on the VM.
For instance for Linux VM:

     http://vmubus001.eastus2.cloudapp.azure.com/index.php 

for Windows VM:

     http://vmnanos001.eastus2.cloudapp.azure.com/index.html 

</p>

Finally, you can open a remote session with the VM.

For instance for Linux VM:

     ssh VMAdmin@vmubus001.eastus2.cloudapp.azure.com

For Windows Server VM:

     mstsc /admin /v:vmwins001.eastus2.cloudapp.azure.com

For Nano Server VM:

     Set-Item WSMan:\\localhost\\Client\\TrustedHosts vmnanos001.eastus2.cloudapp.azure.com </p>
     Enter-PSSession -ComputerName vmnanos001.eastus2.cloudapp.azure.com </p>


## DELETE THE RESOURCE GROUP:
**Azure CLI:** azure group delete "ResourceGroupName" "RegionName"

**Azure CLI 2.0:** az group delete -n "ResourceGroupName" "RegionName"

For instance:

    azure group delete simplevmrg eastus2
	
    az group delete -n simplevmrg 
