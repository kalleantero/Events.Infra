param location string = resourceGroup().location
param tags object
param name string
param sku string
param kind string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  tags: tags
  kind: kind
  sku: {
    name: sku
  }
}

output appServicePlanId string = appServicePlan.id
