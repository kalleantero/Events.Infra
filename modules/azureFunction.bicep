param location string = resourceGroup().location
param tags object
param functionName string
param storageAccountName string
param serverfarmId string
param instrumentationKey string
param keyVaultName string
param functionKeySecretName string

var storageAccountType = 'Standard_LRS'
var functionWorkerRuntime = 'dotnet'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
}

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name:functionName
  location: location
  tags: tags
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: serverfarmId
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~10'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: instrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionWorkerRuntime
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
}

var defaultHostKey = listkeys('${functionApp.id}/host/default', '2016-08-01').functionKeys.default

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: functionKeySecretName
  properties: {
    value: defaultHostKey
  }
}

output defaultHostName string = functionApp.properties.defaultHostName
