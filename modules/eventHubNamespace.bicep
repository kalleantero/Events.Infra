param location string = resourceGroup().location
param name string

@allowed([
  'Basic'
  'Premium'
  'Standard'
])
param tier string = 'Standard'

@minValue(0)
@maxValue(20)
@description('The Event Hubs throughput units')
param capacity int = 1

resource namespace 'Microsoft.EventHub/namespaces@2022-01-01-preview' = {
    name:name
    location:location
    sku:{
	    name:tier
      capacity:capacity
    }
    properties: {
        disableLocalAuth: false
        zoneRedundant: true
        isAutoInflateEnabled: false
        maximumThroughputUnits: 0
        kafkaEnabled: true
    }
}
