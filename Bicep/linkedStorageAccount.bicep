param storageAccountName string
param location string

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2021-04-01' = [for i in range(0, 5): {
  name: concat(storageAccountName, i)
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}]

output storageName string = storageAccountName
output storageEndpoint object = reference(storageAccountName).primaryEndpoints