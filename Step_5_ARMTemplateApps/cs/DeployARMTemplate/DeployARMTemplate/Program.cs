using Microsoft.Azure.Management.ResourceManager;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using System;
using System.IO;
using Microsoft.Azure.Management.Fluent;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
namespace TestARMClientApp
{

    class Program
    {
        static bool GetParameters(string[] args,
            out string subscriptionId,
            out string tenantId,
            out string clientId,
            out string clientSecret,
            out string region,
            out string resourceGroupName,
            out string templatefile,
            out string parameterfile
            )
        {
            bool result = false;
            subscriptionId = string.Empty;
            tenantId = string.Empty;
            clientId = string.Empty;
            clientSecret = string.Empty;
            resourceGroupName = string.Empty;
            region = string.Empty;
            templatefile = string.Empty;
            parameterfile = string.Empty;
            int i = 0;
            while (i < args.Length)
            {
                switch (args[i++])
                {

                    case "--subscriptionId":
                        subscriptionId = args[i++];
                        break;
                    case "--tenantId":
                        tenantId = args[i++];
                        break;
                    case "--clientId":
                        clientId = args[i++];
                        break;
                    case "--clientSecret":
                        clientSecret = args[i++];
                        break;
                    case "--resourceGroup":
                        resourceGroupName = args[i++];
                        break;
                    case "--region":
                        region = args[i++];
                        break;
                    case "--templateFile":
                        templatefile = args[i++];
                        break;
                    case "--parameterFile":
                        parameterfile = args[i++];
                        break;
                    default:
                        break;
                }

            }
            if ((!string.IsNullOrEmpty(subscriptionId)) &&
                (!string.IsNullOrEmpty(tenantId)) &&
                (!string.IsNullOrEmpty(clientId)) &&
                (!string.IsNullOrEmpty(clientSecret)) &&
                (!string.IsNullOrEmpty(resourceGroupName)) &&
                (!string.IsNullOrEmpty(region)) &&
                (!string.IsNullOrEmpty(templatefile)) &&
                (!string.IsNullOrEmpty(parameterfile)))
                result = true;
            return result;
        }

        static Region GetRegion(string region)
        {
            Region result = null;
            if (!string.IsNullOrEmpty(region))
            {
                region = region.ToLower();
                switch (region)
                {
                    case "uswest":
                        result = Region.USWest; break;
                    case "australiacentral2":
                        result = Region.AustraliaCentral2; break;
                    case "indiasouth":
                        result = Region.IndiaSouth; break;
                    case "indiawest":
                        result = Region.IndiaWest; break;
                    case "koreasouth":
                        result = Region.KoreaSouth; break;
                    case "koreacentral":
                        result = Region.KoreaCentral; break;
                    case "chinanorth":
                        result = Region.ChinaNorth; break;
                    case "chinaeast":
                        result = Region.ChinaEast; break;
                    case "australiacentral":
                        result = Region.AustraliaCentral; break;
                    case "germanycentral":
                        result = Region.GermanyCentral; break;
                    case "governmentusvirginia":
                        result = Region.GovernmentUSVirginia; break;
                    case "governmentusiowa":
                        result = Region.GovernmentUSIowa; break;
                    case "governmentusarizona":
                        result = Region.GovernmentUSArizona; break;
                    case "governmentustexas":
                        result = Region.GovernmentUSTexas; break;
                    case "governmentusdodeast":
                        result = Region.GovernmentUSDodEast; break;
                    case "governmentusdodcentral":
                        result = Region.GovernmentUSDodCentral; break;
                    case "germanynortheast":
                        result = Region.GermanyNorthEast; break;
                    case "australiasoutheast":
                        result = Region.AustraliaSouthEast; break;
                    case "indiacentral":
                        result = Region.IndiaCentral; break;
                    case "japanwest":
                        result = Region.JapanWest; break;
                    case "uswest2":
                        result = Region.USWest2; break;
                    case "uscentral":
                        result = Region.USCentral; break;
                    case "useast":
                        result = Region.USEast; break;
                    case "usweast2":
                        result = Region.USEast2; break;
                    case "usnorthcentral":
                        result = Region.USNorthCentral; break;
                    case "australiaeast":
                        result = Region.AustraliaEast; break;
                    case "uswestcentral":
                        result = Region.USWestCentral; break;
                    case "canadacentral":
                        result = Region.CanadaCentral; break;
                    case "canadaeast":
                        result = Region.CanadaEast; break;
                    case "ussouthcentral":
                        result = Region.USSouthCentral; break;
                    case "europenorth":
                        result = Region.EuropeNorth; break;
                    case "europewest":
                        result = Region.EuropeWest; break;
                    case "uksouth":
                        result = Region.UKSouth; break;
                    case "ukwest":
                        result = Region.UKWest; break;
                    case "asiaeast":
                        result = Region.AsiaEast; break;
                    case "asiasoutheast":
                        result = Region.AsiaSouthEast; break;
                    case "japaneast":
                        result = Region.JapanEast; break;
                    case "brazilsouth":
                        result = Region.BrazilSouth; break;
                }
            }
            return result;
        }
        static void Main(string[] args)
        {
            string subscriptionId = string.Empty;
            string tenantId = string.Empty;
            string clientId = string.Empty;
            string clientSecret = string.Empty;
            string resourceGroupName = string.Empty;
            string region = string.Empty;
            string templateFile = string.Empty;
            string parameterFile = string.Empty;

            if (GetParameters(args, out subscriptionId, out tenantId, out clientId, out clientSecret, out region, out resourceGroupName, out templateFile, out parameterFile) == false)
            {
                Console.WriteLine("DeployARMTemplate");
                Console.WriteLine("Syntax:");
                Console.WriteLine("DeployARMTemplate.exe --subscriptionId <SubcriptionID> --tenantId <TenantID> --clientId <ClientID>");
                Console.WriteLine("                      --clientSecret <ClientSecret> --resourceGroup <ResourceGroupName> --region <AzureRegion>");
                Console.WriteLine("                      --templateFile <LocalTemplateFile> --parameterFile <LocalParameterFile>");


                return;
            }

            try
            {

                Region reg = GetRegion(region);
                if (reg == null)
                {
                    Console.WriteLine("Error unknown region: " + region);
                    return;
                }
                AzureCredentials credentials = SdkContext.AzureCredentialsFactory.FromServicePrincipal(clientId, clientSecret, tenantId, AzureEnvironment.AzureGlobalCloud);
                if (credentials != null)
                {
                    Console.WriteLine("Connection with Azure in progress...");
                    var azure = Azure
                        .Configure()
                        .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
                        .Authenticate(credentials)
                        .WithSubscription(subscriptionId);
                    if (azure != null)
                    {
                        Console.WriteLine("Connection successfull");
                        
                        IResourceGroup rg = null;
                        if (azure.ResourceGroups.Contain(resourceGroupName) == true)
                            rg = azure.ResourceGroups.GetByName(resourceGroupName);
                        if (rg == null)
                            rg = azure.ResourceGroups.Define(resourceGroupName).WithRegion(reg).Create();
                        if (rg != null)
                        {
                            string storageAccountName = SdkContext.RandomResourceName("st", 10);

                            Console.WriteLine("Creating storage account: " + storageAccountName);
                            var storage = azure.StorageAccounts.Define(storageAccountName)
                                .WithRegion(reg)
                                .WithExistingResourceGroup(resourceGroupName)
                                .Create();
                            if (storage != null)
                            {
                                Console.WriteLine("Creating storage account: " + storageAccountName + " done");
                                var storageKeys = storage.GetKeys();
                                string storageConnectionString = "DefaultEndpointsProtocol=https;"
                                    + "AccountName=" + storage.Name
                                    + ";AccountKey=" + storageKeys[0].Value
                                    + ";EndpointSuffix=core.windows.net";

                                var account = CloudStorageAccount.Parse(storageConnectionString);
                                var serviceClient = account.CreateCloudBlobClient();
                                if (serviceClient != null)
                                {
                                    Console.WriteLine("Creating container: templates");
                                    var container = serviceClient.GetContainerReference("templates");
                                    if (container != null)
                                    {
                                        container.CreateIfNotExistsAsync().Wait();
                                        var containerPermissions = new BlobContainerPermissions()
                                        { PublicAccess = BlobContainerPublicAccessType.Container };
                                        container.SetPermissionsAsync(containerPermissions).Wait();
                                        Console.WriteLine("Creating container: templates done");

                                        Console.WriteLine("Uploading template file...");

                                        string temppath = templateFile;
                                        string tempfile = System.IO.Path.GetFileName(templateFile);
                                        if (!string.IsNullOrEmpty(tempfile))
                                        {
                                            Console.WriteLine("Uploading template file: " + tempfile);
                                            var templateblob = container.GetBlockBlobReference(tempfile);
                                            templateblob.UploadFromFileAsync(temppath).Wait();
                                            Console.WriteLine("Uploading template file: " + tempfile + " done");


                                            string parapath = parameterFile;
                                            string parafile = System.IO.Path.GetFileName(parameterFile);
                                            if (!string.IsNullOrEmpty(parafile))
                                            {
                                                Console.WriteLine("Uploading parameters file: " + parafile);
                                                var paramblob = container.GetBlockBlobReference(parafile);
                                                paramblob.UploadFromFileAsync(parapath).Wait();
                                                Console.WriteLine("Uploading parameters file: " + parafile + " done");

                                                var templatePath = "https://" + storageAccountName + ".blob.core.windows.net/templates/" + tempfile;
                                                var paramPath = "https://" + storageAccountName + ".blob.core.windows.net/templates/" + parafile;
                                                Console.WriteLine("Deploying template file: " + templatePath);
                                                var deployment = azure.Deployments.Define("myDeployment")
                                                    .WithExistingResourceGroup(resourceGroupName)
                                                    .WithTemplateLink(templatePath, "1.0.0.0")
                                                    .WithParametersLink(paramPath, "1.0.0.0")
                                                    .WithMode(Microsoft.Azure.Management.ResourceManager.Fluent.Models.DeploymentMode.Incremental)
                                                    .Create();
                                                Console.WriteLine("Deploying template file done");
                                                Console.WriteLine("Press enter to delete the resource group...");
                                                Console.ReadLine();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (rg != null)
                            azure.ResourceGroups.DeleteByName(resourceGroupName);


                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Deploying template file failed");
                Console.WriteLine("Exception: " + ex.Message);
            }
        }
    }
}
