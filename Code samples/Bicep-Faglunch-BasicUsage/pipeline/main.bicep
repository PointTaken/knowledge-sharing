@allowed([
  'dev'
  'test'
  'prod'
])
@description('The name of the environment')
param env string

@description('Used to name the Azure resources of the project | {abbreviation}-{customerName}-{projectName}-{environment}') 
@maxLength(15) 
param projectName string
param location string = resourceGroup().location
param lastDeploy string = utcNow('dd-MM-yyyy THH:mmZ') 

@description('Optional. The name of the customer')
@maxLength(2)
param customerName string = 'pt'

var config = loadJsonContent('./main.environmentConfiguration.json')[env] // Bicep configuration set pattern - https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/patterns-configuration-set
var environmentLetter = substring(env, 0, 1)

var resourceName = '${customerName}-${projectName}-${environmentLetter}'

var tags = {
  project: projectName
  team: 'faglunch'
  environment: env
  lastDeploy: lastDeploy
}

resource resourceGroupTags 'Microsoft.Resources/tags@2021-04-01' = {
  name: 'default'
  properties: {
    tags: tags
  }
}

module storageAccount 'modules/st-storageaccount.bicep' = {
  name: 'storageAccount'
  params: {
    resourceName: resourceName
    location: location
    tags: tags
    storageSKU: config.storageSKU
  }
}

var keyVaultSecrets = [
  {
    name: '${storageAccount.outputs.name}-connectionstring'
    value: storageAccount.outputs.connectionString
  }
]

module keyVault 'modules/kv-keyvault.bicep' = {
  name: 'keyVault'
  params: {
    resourceName: resourceName
    location: location
    tags: tags
    keyVaultSecrets: keyVaultSecrets
  }
}

output storageAccountName string = storageAccount.outputs.name 
