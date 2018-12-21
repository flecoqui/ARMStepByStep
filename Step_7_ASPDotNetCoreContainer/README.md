# Deployment of a ASP.Net Core React Redux container locally or on Azure

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_6_DataScienceVMTemplate%2F101-vm-data-science-windows%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_6_DataScienceVMTemplate%2F101-vm-data-science-windows%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## OVERVIEW
This sample application show how to:
1.   Build a .Net Core ASP.NET React Redux application
2.   Deploy the same application locally on your machine 
3.   Deploy the same application locally in a Docker Container
4.   Deploy the same application in Container in Azure Kubernetes Service (AKS)

## BUILD A .NET CORE ASP.NET REACT REDUX APPLICATION

### Pre-requisite
In order to build a .Net Core Application you need to install the latest .NetCore SDK on your machine running Linux, MacOS or Windows 10.
You can download the SDK from [there: https://azure.microsoft.com/en-us/free/](https://azure.microsoft.com/en-us/free/)
Once the .Net Core SDK is installed you can build an ASP.Net Core Application.

### Creating the application
You can either clone the application from this repository, in that case you need to clone the following repository: 
[https://github.com/flecoqui/ARMStepByStep.git](https://github.com/flecoqui/ARMStepByStep.git) 
and open a command shell window in the folder <InstallationFolder>\Step_7_ASPDotNetCoreContainer\aspnetcoreapp\aspnetcoreapp

or create the application from the .Net Core SDK:

1. Open a command shell window
2. Change Directory to your dev directory

    C:\users\me>
    C:\users\me> cd \dev
    C:\dev> 

3. Create a directory called aspnetcoreapp 

    C:\dev> mkdir aspnetcoreapp
    C:\dev> 


4. Change directory to aspnetcoreapp 

    C:\dev> cd aspnetcoreapp
    C:\dev\aspnetcoreapp> 

5. Create the application using the following command: 

    C:\dev\aspnetcoreapp> dotnet new reactredux 



### Building the application

1. Build the application using the following command: 

    C:\dev\aspnetcoreapp> dotnet build 

### Running the application locally

1. Run the application using the following command: 

    C:\dev\aspnetcoreapp> dotnet run 

2. With your favorite Browser open the url http://localhost:5000 
As it's an http connection and not a https connection, the browser will block the connection click on a link displayed (Advanced or Details) on the screen to open an http connection with the ASP.Net Core Application running on your machine.

<img src="http://azuredeploy.net/deploybutton.png"/>
   
## CREATE RESOURCE GROUP:
1.	Azure Subscription
https://azure.microsoft.com/en-us/free/
2.	install .NetCore 2.2 SDK
https://dotnet.microsoft.com/download 
 
3.	Docker installed on your local machine
https://docs.docker.com/docker-for-windows/install/

https://hub.docker.com/editions/community/docker-ce-desktop-windows?tab=description 
Download Docker
Install Docker
 

 

After few minutes Docker should run

 

https://docs.microsoft.com/fr-fr/azure/container-service/kubernetes/container-service-kubernetes-walkthrough 


https://github.com/Azure-Samples/azure-voting-app-redis 

dotnet new reactredux

dotnet build


Deploy locally :
cd samples
cd aspnetcoreapp\aspnetcoreapp
dotnet run

dotnet publish -c Release -o out
cd out
dotnet aspnetapp.dll


https://localhost:5001/ 


Deploy in local Docker

cd samples
cd aspnetcoreapp 
docker build --pull -t aspnetcoreapp .
docker run --name aspnetcore_sample --rm -it -p 8000:80 aspnetcoreapp 


http://localhost:8000/



https://github.com/dotnet/dotnet-docker/tree/master/samples/aspnetapp 



BUILD DOCKER IMAGE
https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task

cd aspnetcoreapp\
Folder wih dockerfile

az group create --resource-group testacrrg --location eastus2
az acr create --resource-group testacrrg --name testacreu2  --sku Standard --location eastus2  


az acr build --registry testacreu2   --image aspnetcorereactredux:v1 .

 

az keyvault create --resource-group testacrrg --name testacrkv
 

# Create service principal, store its password in AKV (the registry *password*)
az keyvault secret set  --vault-name testacrkv --name testacreu2-pull-pwd --value $(az ad sp create-for-rbac --name testacreu2-pull --scopes $(az acr show --name testacreu2 --query id --output tsv) --role reader --query password --output tsv)

 

az ad sp create-for-rbac --name testacreu2-pull --scopes  /subscriptions/e5c9fc83-fbd0-4368-9cb6-1b5823479b6d/resourceGroups/testacrrg/providers/Microsoft.ContainerRegistry/registries/testacreu2 --role reader --query password --output tsv

 

az keyvault secret set  --vault-name testacrkv --name testacreu2-pull-pwd --value 783c8982-1c2b-4048-a70f-c9a21f5eba8f 

 


az keyvault secret set --vault-name testacrkv --name testacreu2-pull-usr --value $(az ad sp show --id http://testacreu2-pull --query appId --output tsv)

 

az ad sp show --id http://testacreu2-pull --query appId --output tsv
 
40e21cbe-9b70-469f-80da-4369e02ebc58

az keyvault secret set --vault-name testacrkv --name testacreu2-pull-usr �-value 40e21cbe-9b70-469f-80da-4369e02ebc58
 



az container create \
    --resource-group $RES_GROUP \
    --name acr-tasks \
    --image $ACR_NAME.azurecr.io/helloacrtasks:v1 \
    --registry-login-server $ACR_NAME.azurecr.io \
    --registry-username $(az keyvault secret show --vault-name $AKV_NAME --name $ACR_NAME-pull-usr --query value -o tsv) \
    --registry-password $(az keyvault secret show --vault-name $AKV_NAME --name $ACR_NAME-pull-pwd --query value -o tsv) \
    --dns-name-label acr-tasks-$ACR_NAME \
    --query "{FQDN:ipAddress.fqdn}" \
    --output table



az container create \
    --resource-group testacrrg \
    --name acr-tasks \
    --image testacreu2.azurecr.io/aspnetcorereactredux:v1 \
    --registry-login-server testacreu2.azurecr.io \
    --registry-username $(az keyvault secret show --vault-name testacrkv --name testacreu2-pull-usr --query value -o tsv) \
    --registry-password $(az keyvault secret show --vault-name testacrkv --name testacreu2-pull-pwd --query value -o tsv) \
    --dns-name-label acr-tasks-testacreu2 \
    --query "{FQDN:ipAddress.fqdn}" \
    --output table

az container create --resource-group testacrrg --name acr-tasks --image testacreu2.azurecr.io/aspnetcorereactredux:v1 --registry-login-server testacreu2.azurecr.io --registry-username $(az keyvault secret show --vault-name testacrkv --name testacreu2-pull-usr --query value -o tsv) --registry-password $(az keyvault secret show --vault-name testacrkv --name testacreu2-pull-pwd --query value -o tsv) --dns-name-label acr-tasks-testacreu2 --query "{FQDN:ipAddress.fqdn}" --output table

az keyvault secret show --vault-name testacrkv --name testacreu2-pull-usr --query value -o tsv
 

40e21cbe-9b70-469f-80da-4369e02ebc58

az keyvault secret show --vault-name testacrkv --name testacreu2-pull-pwd --query value -o tsv
 

783c8982-1c2b-4048-a70f-c9a21f5eba8f
az container create --resource-group testacrrg --name acr-tasks --image testacreu2.azurecr.io/aspnetcorereactredux:v1 --registry-login-server testacreu2.azurecr.io --registry-username 40e21cbe-9b70-469f-80da-4369e02ebc58 --registry-password 783c8982-1c2b-4048-a70f-c9a21f5eba8f --dns-name-label acr-tasks-testacreu2 --query "{FQDN:ipAddress.fqdn}" --output table


 

http://acr-tasks-testacreu2.eastus2.azurecontainer.io/

az container attach --resource-group testacrrg --name acr-tasks 

 


az container delete --resource-group $RES_GROUP --name acr-tasks

az container delete --resource-group testacrrg --name acr-tasks

 



https://docs.microsoft.com/fr-fr/azure/aks/tutorial-kubernetes-deploy-cluster

Deploy AKS:

az ad sp create-for-rbac --skip-assignment
 

678ca0ab-31ba-405e-8392-245946a19d79

69d408bb-dd2c-47a1-8e14-063a3cbb36f5
az acr show --resource-group myResourceGroup --name <acrName> --query "id" --output tsv

az acr show --resource-group testacrrg --name testacreu2 --query "id" --output tsv
 



az role assignment create --assignee <appId> --scope <acrId> --role Reader

/subscriptions/e5c9fc83-fbd0-4368-9cb6-1b5823479b6d/resourceGroups/testacrrg/providers/Microsoft.ContainerRegistry/registries/testacreu2 

az role assignment create --assignee 678ca0ab-31ba-405e-8392-245946a19d79 --scope /subscriptions/e5c9fc83-fbd0-4368-9cb6-1b5823479b6d/resourceGroups/testacrrg/providers/Microsoft.ContainerRegistry/registries/testacreu2 --role Reader
 

az aks create   --resource-group myResourceGroup --name myAKSCluster --node-count 1 --service-principal <appId> --client-secret <password> --generate-ssh-keys

az aks create   --resource-group testacrrg --name testnetcoreakscluster --node-count 1 --service-principal 678ca0ab-31ba-405e-8392-245946a19d79  --client-secret 69d408bb-dd2c-47a1-8e14-063a3cbb36f5 --generate-ssh-keys

 




az aks install-cli


az aks get-credentials --resource-group myResourceGroup --name myAKSCluster

az aks get-credentials --resource-group testacrrg --name testnetcoreakscluster

 


kubectl get nodes

 


Deployer l�image
az acr list --resource-group  testacrrg

 

az acr repository list --name testacreu2 --output table

 


Deploy with kubectl: 

kubectl run aspnetcorereactredux --image testacreu2.azurecr.io/aspnetcorereactredux:v1 --port 80 
kubectl expose deployment aspnetcorereactredux --type="LoadBalancer" --port=80
kubectl get services

 

kubectl get all  --export=true  -o yaml

kubectl apply -f aspnetcoreapp.yaml


kubectl scale deployment aspnetcorereactredux --replicas=4


 

Test Resiliency

kubectl get pods


kubectl delete pod aspnetcorereactredux-684bfc8cc-2spjj

 

http://104.209.196.251/




kubectl apply -f azure-vote-all-in-one-redis.yaml




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


