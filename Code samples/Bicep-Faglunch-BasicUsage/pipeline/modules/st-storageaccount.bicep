@maxLength(22)
@minLength(1)
@description('The resource name suffix | The storage account is named st{resourceName}')
param resourceName string

@description('Optional. The location of the resources')
param location string = resourceGroup().location

@description('Optional. The tags of the resources')
param tags object = {}

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
@description('Optional. The sku of the storage account')
param storageSKU string = 'Standard_LRS'

var abbreviations = loadJsonContent('abbreviations.json')

var uniqueSuffixForResourceGroup = '${uniqueString(resourceGroup().id)}xxxxx'
var nameWithoutSuffix = '${abbreviations.storageAccount}${replace(resourceName, '-', '')}'
var storageAccountName = substring('${nameWithoutSuffix}${uniqueSuffixForResourceGroup}', 0, 24)

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
        queue: {
          enabled: true
        }
        table: {
          enabled: true
        }
      }
    }
  }
  tags: tags
}

var connectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'

output connectionString string = connectionString
output name string = storageAccount.name
