@maxLength(24)
@minLength(1)
@description('The name of the existing key vault')
param keyVaultName string

@description('The name of the secret | alphanumeric characters and dashes only')
param secretName string

@description('The value of the secret')
@secure()
param secretValue string

@description('Optional. The tags of the resources')
param tags object = {}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: '${keyVaultName}/${secretName}' 
  properties: {
    value: secretValue
  }
  tags: tags
}

@description('The name of the created secret')
output secretName string = secretName
@description('The uri to the created secret')
output keyVaultSecretUri string = keyVaultSecret.properties.secretUri
@description('The uri to the created secret with version')
output keyVaultSecretUriWithVersion string = keyVaultSecret.properties.secretUriWithVersion
@description('A string that can be used as an app setting key vault reference')
output appSettingReference string = '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${secretName})'
