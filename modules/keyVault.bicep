param location string = resourceGroup().location
param sku string
param tags object
param name string
param objectId string

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        objectId: objectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'list'
          ]
        }
      }
    ]
    sku: {
      name: sku
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}
