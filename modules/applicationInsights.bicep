param location string = resourceGroup().location
param tags object
param workspaceId string
param name string

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceId
  }
}

output applicationInsightsConnectionString string = applicationInsights.properties.ConnectionString
output applicationInsightsId string = applicationInsights.id
output applicationInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey
