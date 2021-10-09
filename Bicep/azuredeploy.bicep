@minLength(3)
@maxLength(11)
param storagePrefix string
param location string = resourceGroup().location
param appServicePlanName string = 'testPlan'

@minLength(2)
param webAppName string
param linuxFxVersion string = 'php|7.0'
param resourceTags object = {
  Environment: 'Dev'
  Project: 'Tutorial'
}

var storageAccountName = concat(storagePrefix, uniqueString(resourceGroup().id))
var webAppPortalName_var = concat(webAppName, uniqueString(resourceGroup().id))

module linkedTemplate 'linkedStorageAccount.bicep' = {
  name: 'linkedTemplate'
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}

resource appServicePlanName_resource 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    reserved: true
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource webAppPortalName 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppPortalName_var
  location: location
  tags: resourceTags
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanName_resource.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}