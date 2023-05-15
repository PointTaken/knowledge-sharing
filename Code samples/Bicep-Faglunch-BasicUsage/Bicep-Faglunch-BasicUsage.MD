# Demo code from Faglunch: intro til Bicep
This folder examplifies infrastructure as code using Bicep to deploy Azure resources. 
- `main.bicep` defines resources from three different modules to create a storage account, a key vault and a key vault secret
- `main.bicep` shows how to use output from modules
- `deploy.ps1` deploys the resources defined in `main.bicep` to Azure
- `deploy-infrastructure-job` shows how to deploy the bicep definition in a Azure Devops pipeline using the AzureCLI@2 task

## How to run the example

0. Install VS code, the bicep VS code extension, AZ CLI, and the Bicep CLI
1. Run `az login` with powershell
2. Run `az account list` to see your available subscriptions
3. Run `$subscriptionId = "xxx"`
4. Run `az account set --subscription $subscriptionId`
5. Deploy resources with `. .\deploy.ps1 -projectName faglunchbicep -env dev -location westeurope -customerName pt` (the extra '. '  is called a dot source and make variables set in the script available in the current session scope)
6. Print the output with 