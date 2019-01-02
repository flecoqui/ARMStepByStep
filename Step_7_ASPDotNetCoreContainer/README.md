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

### BUILDING A CONTAINER IMAGE IN AZURE
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


4. Build the container image and register it in the new Azure Container Registry with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az acr build --registry "ACRName" --image "ImageName:ImageTag" "localFolder"</p>
For instance:

        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az acr build --registry acreu2   --image aspnetcorereactredux:v1 .

After few minutes, the image should be available in the new registry:

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

### DEPLOYING TO AZURE CONTAINER INSTANCES (ACI)
Your container image is now available from your container registry in Azure.
You can deploy this image from your registry immediately.

#### CONFIGURING REGISTRY AUTHENTICATION
In this sections, you create an Azure Key Vault and Service Principal, then deploy the container to Azure Container Instances (ACI) using Service Principal's credentials.

1. Create a key vault with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az keyvault create --resource-group "ResourceGroupName" --name "AzureKeyVaultName"</p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az keyvault create --resource-group acrrg --name acrkv
 
2. Display the ID associated with the new Azure Container Registry using the following command:</p>
In order to create the Service Principal you need to know the ID associated with the new Azure Container Registry, you can display this information with the following command:</p>
**Azure CLI 2.0:** az acr show --name "ACRName" --query id --output tsv</p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az acr show --name acreu2 --query id --output tsv

3. Create a Service Principal and display the password with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az ad sp create-for-rbac --name "ACRSPName" --scopes "ACRID" --role acrpull --query password --output tsv</p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az ad sp create-for-rbac --name acrspeu2 --scopes /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/acrrg/providers/Microsoft.ContainerRegistry/registries/acreu2 --role acrpull --query password --output tsv

After few seconds the result (ACR Password) is displayed:

        Changing "spacreu2" to a valid URI of "http://acrspeu2", which is the required format used for service principal names
        Retrying role assignment creation: 1/36
        Retrying role assignment creation: 2/36
        yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy


4. Store credentials (ACR password) with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az keyvault secret set  --vault-name "AzureKeyVaultName" --name "PasswordSecretName" --value "ServicePrincipalPassword" </p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az keyvault secret set  --vault-name acrkv --name acrspeu2-pull-pwd --value yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy
 
5. Display the Application ID associated with the new Service Principal with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az ad sp show --id http://"ACRSPName" --query appId --output tsv</p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az ad sp show --id http://acrspeu2 --query appId --output tsv

After few seconds the result (ACR AppId) is displayed:

        wwwwwwww-wwww-wwww-wwww-wwwwwwwwwwww



6. Store credentials (ACR AppID) with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az keyvault secret set  --vault-name "AzureKeyVaultName" --name "AppIDSecretName" --value "ServicePrincipalAppID" </p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az keyvault secret set  --vault-name acrkv --name acrspeu2-pull-usr --value wwwwwwww-wwww-wwww-wwww-wwwwwwwwwwww
 

The Azure Key Vault contains now the Azure Container Registry AppID and Password. 

#### DEPLOYING THE IMAGE IN AZURE CONTAINER INSTANCE
You can now deploy the image using the credentials stored in Azure Key Vault.

1. You need first to retrieve the AppID from the Azure Key Vault with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az keyvault secret show --vault-name "AzureKeyVaultName" --name "AppIDSecretName" --query value -o tsv  </p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az keyvault secret show --vault-name acrkv --name acrspeu2-pull-usr --query value -o tsv
 
After few seconds the result (ACR AppId) is displayed:

        wwwwwwww-wwww-wwww-wwww-wwwwwwwwwwww

2. You need also to retrieve the Password from the Azure Key Vault with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az keyvault secret show --vault-name "AzureKeyVaultName" --name "PasswordSecretName" --query value -o tsv  </p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az keyvault secret show --vault-name acrkv --name acrspeu2-pull-pwd --query value -o tsv
 
After few seconds the result (Password) is displayed:

        yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy


3. With the AppID and the Password you can now deploy the image in a container with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az container create --resource-group "ResourceGroupName"  --name "ContainerGroupName" --image "ACRName".azurecr.io/"ImageName:ImageTag" --registry-login-server "ACRName".azurecr.io --registry-username "ServicePrincipalAppID" --registry-password "ServicePrincipalPassword" --dns-name-label "InstanceName" --query "{FQDN:ipAddress.fqdn}" --output table </p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az container create --resource-group acrrg --name acr-tasks --image acreu2.azurecr.io/aspnetcorereactredux:v1 --registry-login-server acreu2.azurecr.io --registry-username d384b6b7-9d83-4f8c-9fa0-8909b117e89d --registry-password 52018750-2458-4e7b-a62e-8778486ebf55 --dns-name-label acr-tasks-acreu2 --query "{FQDN:ipAddress.fqdn}" --output table
 
After few seconds the command returns the DNS Name of the new instance:

        ------------------------------------------
        "InstanceName"."RegionName".azurecontainer.io

For instance:

        ------------------------------------------
        acr-tasks-acreu2.eastus2.azurecontainer.io

4. With your favorite Browser open the url http://"InstanceDNSName"/ 
As it's an http connection and not a https connection, the browser will block the connection click on a link displayed (Advanced or Details) on the screen to open an http connection with the ASP.Net Core Application running on your machine.
The following page should be displayed on your browser

<img src="https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_7_ASPDotNetCoreContainer/Docs/aspnetacipage.png"/>
   


For instance:

        http://acr-tasks-acreu2.eastus2.azurecontainer.io/ 

#### VERIFYING THE CONTAINER RUNNING IN AZURE
You can recevie on your local machine the logs from the Container running in Azure with Azure CLI with the following command: </p>
**Azure CLI 2.0:** az container attach --resource-group "ResourceGroupName" --name "ContainerGroupName"  </p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az container attach --resource-group acrrg --name acr-tasks





### DEPLOYING TO AZURE KUBERNETES SERVICE (AKS)
Using the same container image in the Azure Container Registry you can deploy the same container image in Azure Kubernetes Service (AKS).</p>
You'll find further information here:</p>
https://docs.microsoft.com/fr-fr/azure/aks/tutorial-kubernetes-deploy-cluster 


#### CREATING SERVICE PRINCIPAL FOR AKS DEPLOYMENT

1. With Azure CLI create an Service Principal:
**Azure CLI 2.0:** az ad sp create-for-rbac --skip-assignment </p>
For instance:


          C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az ad sp create-for-rbac --skip-assignment
 
 The command returns the following information associated with the new Service Principal:
 - appID
 - displayName
 - name
 - password
 - tenant

For instance:


          AppId                                 Password                            
          ------------------------------------  ------------------------------------
          d604dc61-d8c0-41e2-803e-443415a62825  097df367-7472-4c23-96e1-9722e1d8270a



2. Display the ID associated with the new Azure Container Registry using the following command:</p>
In order to allow the Service Principal to have access to the Azure Container Registry you need to display the ACR resource ID with the following command:</p>
**Azure CLI 2.0:** az acr show --name "ACRName" --query id --output tsv</p>
For instance:


        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az acr show --name acreu2 --query id --output tsv

The command returns ACR resource ID.

For instance:

        /subscriptions/e5c9fc83-fbd0-4368-9cb6-1b5823479b6d/resourceGroups/acrrg/providers/Microsoft.ContainerRegistry/registries/acreu2


3. Allow the Service Principal to have access to the Azure Container Registry with the following command:</p>
**Azure CLI 2.0:** az role assignment create --assignee "AppID" --scope "ACRReourceID" --role Reader
 For instance:

        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az role assignment create --assignee d604dc61-d8c0-41e2-803e-443415a62825 --scope /subscriptions/e5c9fc83-fbd0-4368-9cb6-1b5823479b6d/resourceGroups/acrrg/providers/Microsoft.ContainerRegistry/registries/acreu2 --role Reader


#### CREATING A KUBERNETES CLUSTER
Now you can create the Kubernetes Cluster in Azure. </p>


1. With the following Azure CLI command create the Azure Kubernetes Cluster:</p>
**Azure CLI 2.0:** az aks create --resource-group "ResourceGroupName" --name "AKSClusterName" --node-count 1 --service-principal "SPAppID" --client-secret "SPPassword" --generate-ssh-keys </p>

For instance:


        az aks create --resource-group acrrg --name netcoreakscluster --node-count 1 --service-principal d604dc61-d8c0-41e2-803e-443415a62825   --client-secret 097df367-7472-4c23-96e1-9722e1d8270a --generate-ssh-keys

 
2. After few minutes, the Cluster is deployed. To connect to the cluster from your local computer, you use the Kubernetes Command Line Client. Use the following Azure CLI command to install the Kubernetes Command Line Client:
**Azure CLI 2.0:** az aks install-cli </p>


3. Connect the Kubernetes Command Line Client to your Cluster in Azure using the following Azure CLI command:
**Azure CLI 2.0:** az aks get-credentials --resource-group "ResourceGroupName" --name "AKSClusterName" </p>

For instance:

        az aks get-credentials --resource-group acrrg --name netcoreakscluster


4. Check the connection from the Kubernetes Command Line Client with the following command:
**kubectl** kubectl get nodes

The commmand will return information about the Kuberentes nodes.

For instance:

        NAME                       STATUS    ROLES     AGE       VERSION
        aks-nodepool1-38201324-0   Ready     agent     16m       v1.9.11

You are now connected to your cluster from your local machine.

#### DEPLOYING THE IMAGE TO A KUBERNETES CLUSTER IN AZURE

1. You can list the Azure Container Registry per Resource Group using the following Azure CLI command: </p>
**Azure CLI 2.0:** az acr list --resource-group  "ResourceGroupName" </p>

For instance: 
 

        az acr list --resource-group  testacrrg

 it returns the list of ACR associated with this resource group.

 For instance:

        NAME    RESOURCE GROUP    LOCATION    SKU       LOGIN SERVER       CREATION DATE         ADMIN ENABLED
        ------  ----------------  ----------  --------  -----------------  --------------------  ---------------
        acreu2  acrrg             eastus2     Standard  acreu2.azurecr.io  2019-01-02T09:31:12Z


2. You can list the repository in each Azure Container Registry  using the following Azure CLI command: </p>
**Azure CLI 2.0:** az acr repository list --name "ACRName" --output table </p>

For instance: 
 

        az acr repository list --name acreu2 --output table


It returns the list of images.

For instance:

        Result
        --------------------
        aspnetcorereactredux


3. You can now deploy the image with Kubernetes Command Line Client: </p>
**kubectl** kubectl run "ImageDeploymentName" --image "ACRName".azurecr.io/"ImageName":v1 --port 80 </p>

For instance: 
 

        kubectl run aspnetcorereactredux --image acreu2.azurecr.io/aspnetcorereactredux:v1 --port 80 



4. Expose your container to the internet with Kubernetes Command Line Client: </p>
**kubectl** kubectl expose deployment "ImageDeploymentName" --type="LoadBalancer" --port=80 </p>

For instance: 
 

        kubectl expose deployment aspnetcorereactredux --type="LoadBalancer" --port=80 



5. You can check the creation of the services with Kubernetes Command Line Client: </p>
**kubectl** kubectl get services </p>

For instance: 
 

        kubectl get services 

After the deployment of the image the public IP address is not yet available, the EXTERNAL-IP field is still in pending state.


        NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
        aspnetcorereactredux   LoadBalancer   10.0.15.205   <pending>     80:30301/TCP   45s
        kubernetes             ClusterIP      10.0.0.1      <none>        443/TCP        37m

After few minutes the public IP address is available:


        NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
        aspnetcorereactredux   LoadBalancer   10.0.15.205   104.210.7.67   80:30301/TCP   2m
        kubernetes             ClusterIP      10.0.0.1      <none>         443/TCP        38m




6. With your favorite Browser open the url http://"EXTERNAL-IP"/ 
As it's an http connection and not a https connection, the browser will block the connection click on a link displayed (Advanced or Details) on the screen to open an http connection with the ASP.Net Core Application running on your machine.
The following page should be displayed on your browser

<img src="https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_7_ASPDotNetCoreContainer/Docs/aspnetacipage.png"/>
   


For instance:

        http://104.210.7.67/ 
 

#### VERIFYING THE IMAGE DEPLOYMENT IN A KUBERNETES CLUSTER IN AZURE

kubectl get all  --export=true  -o yaml

kubectl apply -f aspnetcoreapp.yaml


kubectl scale deployment aspnetcorereactredux --replicas=4


 

Test Resiliency

kubectl get pods


kubectl delete pod aspnetcorereactredux-684bfc8cc-2spjj

 

http://104.209.196.251/




kubectl apply -f azure-vote-all-in-one-redis.yaml



## CLEANING UP RESOURCES 
You can clean up all the resources create during this chapter with the following commands:</p>

1. Delete the Azure Container Instance with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az container delete --resource-group "ResourceGroupName" --name "ContainerGroupName"  </p>
For instance:

        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az container delete --resource-group acrrg --name acr-tasks


2. Delete the resource group  with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az group delete --resource-group "ResourceGroupName"   </p>
For instance:

        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az group delete --resource-group acrrg 



3. Delete the Service Principal with Azure CLI using the following command:</p>
**Azure CLI 2.0:** az ad sp delete --id http://"ACRSPName"  </p>
For instance:

        C:\git\me\ARMStepByStep\Step_7_ASPDotNetCoreContainer\aspnetcoreapp> az ad sp delete --id http://acrspeu2 

