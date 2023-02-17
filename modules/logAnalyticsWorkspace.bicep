param location string = resourceGroup().location
param tags object
param name string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
