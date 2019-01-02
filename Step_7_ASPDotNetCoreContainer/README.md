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
The following page should be displayed on your browser

<img src="https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_7_ASPDotNetCoreContainer/Docs/aspnetpage.png"/>
   

## DEPLOY A .NET CORE ASP.NET REACT REDUX APPLICATION LOCALLY

1. Build a release build of the application  


        C:\dev\aspnetcoreapp> dotnet publish -c Release -o out



2. Run a release build of the application  


        C:\dev\aspnetcoreapp> cd out
        C:\dev\aspnetcoreapp\out> dotnet aspnetcoreapp.dll


3. With your favorite Browser open the url http://localhost:5000 
As it's an http connection and not a https connection, the browser will block the connection click on a link displayed (Advanced or Details) on the screen to open an http connection with the ASP.Net Core Application running on your machine.
The following page should be displayed on your browser

<img src="https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_7_ASPDotNetCoreContainer/Docs/aspnetpage.png"/>
   


## DEPLOY A .NET CORE ASP.NET REACT REDUX APPLICATION IN A LOCAL CONTAINER

### Pre-requisite
First you need to install Docker on your machine:
You can download Docker for Windows from there https://docs.docker.com/docker-for-windows/install/
You can also download Docker from there: https://hub.docker.com/editions/community/docker-ce-desktop-windows?tab=description  
Once Docker is installed you can deploy your application in a local container.

### Deployment

1. Open a command shell window in the project folder  


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> 

2. Check if the Dockerfile file is present in this folder.


        FROM microsoft/dotnet:2.2-sdk AS build
        WORKDIR /app

        # Add nodeJs required for reactjs
        RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
        RUN apt-get install -y nodejs

        # copy csproj and restore as distinct layers
        COPY aspnetcoreapp/*.csproj ./aspnetcoreapp/
        WORKDIR /app/aspnetcoreapp
        RUN dotnet restore

        # copy everything else and build app
        WORKDIR /app
        COPY aspnetcoreapp/. ./aspnetcoreapp/
        WORKDIR /app/aspnetcoreapp
        RUN dotnet publish -c Release -o out

        FROM microsoft/dotnet:2.2-aspnetcore-runtime AS runtime
        WORKDIR /app
        COPY --from=build /app/aspnetcoreapp/out ./
        ENTRYPOINT ["dotnet", "aspnetcoreapp.dll"]


2. Build a container from the application using the following command:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> docker build --pull -t aspnetcoreapp .



3. Run the application container using the following command:  


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> docker run --name aspnetcore_sample --rm -it -p 8000:80 aspnetcoreapp 



4. With your favorite Browser open the url http://localhost:8000/ 
As it's an http connection and not a https connection, the browser will block the connection click on a link displayed (Advanced or Details) on the screen to open an http connection with the ASP.Net Core Application running on your machine.
The following page should be displayed on your browser

<img src="https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_7_ASPDotNetCoreContainer/Docs/aspnetcontainerpage.png"/>
   

You find further information about ASP.NET application running in Docker Container on this page: https://github.com/dotnet/dotnet-docker/tree/master/samples/aspnetapp

## DEPLOY A .NET CORE ASP.NET REACT REDUX APPLICATION IN A CONTAINER RUNNING IN AZURE

### Pre-requisite
First you need an Azure subscription.
You can subscribe here:  https://azure.microsoft.com/en-us/free/ . </p>
Moreover, we will use Azure CLI v2.0 to deploy the resources in Azure.
You can install Azure CLI on your machine running Linux, MacOS or Windows from hre: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest 

You can get further information about Azure Kubernetes Service here: https://docs.microsoft.com/fr-fr/azure/aks/kubernetes-walkthrough .</p>
You can check the sample application here: https://github.com/Azure-Samples/azure-voting-app-redis

### BUILDING A DOCKER IMAGE
Before deploying your application in a container running in Azure, you need to create a container image and deploy it in the cloud with Azure Container Registry:
https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task


1. Open a command shell window in the project folder  


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> 

2. Create a resource group with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az group create --resource-group "ResourceGroupName" --location "RegionName"</p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az group create --resource-group acrrg --location eastus2

3. Create an Azure Container Registry with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az acr create --resource-group "ResourceGroupName" --name "ACRName" --sku "ACRSku" --location "RegionName"</p>
For instance:

        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az acr create --resource-group acrrg --name acreu2  --sku Standard --location eastus2  


4. Build the image and register it in the new Azure Container Registry with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az acr build --registry "ACRName" --image "ImageName:ImageTag" "localFolder"</p>
For instance:

        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az acr build --registry acreu2   --image aspnetcorereactredux:v1 .

After few minutes, the image should be availble in the new registry:

For instance:

        2019/01/02 09:36:09
        - image:
            registry: acreu2.azurecr.io
            repository: aspnetcorereactredux
            tag: v1
            digest: sha256:13fc8dfd45366d6be1171029bd3a1576b17d2311ddeca1ed8b5a5ce1b58f6863
          runtime-dependency:
            registry: registry.hub.docker.com
            repository: microsoft/dotnet
            tag: 2.2-aspnetcore-runtime
            digest: sha256:96bad363c0c833d9f927030c20a49d220f8c074193aebf1b0d71733e2886b8dd
          buildtime-dependency:
          - registry: registry.hub.docker.com
            repository: microsoft/dotnet
            tag: 2.2-sdk
            digest: sha256:5f4e2fb3cf2b33a7bad1ebdf3db5961fbddb5d3c0214400a10facbdb6bf957bf
          git: {}
        
        Run ID: ch1 was successful after 3m0s


### Create service principal, store its password in AKV (the registry *password*)

        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az keyvault create --resource-group testacrrg --name testacrkv
 


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

### Deploy AKS:

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


