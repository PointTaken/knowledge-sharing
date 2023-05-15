@maxLength(21)
@minLength(1)
@description('The key vault resource name suffix | kv-{resourceName}')
param resourceName string

@description('Optional. The location of the resources')
param location string = resourceGroup().location

@description('Optional. The tags of the resources')
param tags object = {}

@description('''Optional. Array of keyvault secret objects like [
  { 
    "name": "nameThatIsEasyToIdentifyForSomeoneElse"
    "value": "somethingSecret"
  }
]''')
param keyVaultSecrets array = []

var abbreviations = loadJsonContent('abbreviations.json')
var keyVaultName = '${abbreviations.keyVault}-${resourceName}' 

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
  }
  tags: tags
}

module createKeyVaultSecretModule 'kv-add-secret.bicep' = [for secret in keyVaultSecrets: {
  name: 'addSecret-${secret.name}'
  params: {
    keyVaultName: keyVault.name
    secretName: secret.name
    secretValue: secret.value
    tags: tags
  }
}]

@description('The name of the key vault')
output keyVaultName string = keyVault.name
