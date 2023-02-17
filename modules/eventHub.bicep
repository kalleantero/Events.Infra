param name string
param consumerGroups array
param authorizationRules object
param namespaceName string
param messageRetentionInDays int
param partitionCount int

resource hub 'Microsoft.EventHub/namespaces/eventhubs@2022-01-01-preview' = {
    name: '${namespaceName}/${name}'
    properties: {
        messageRetentionInDays: messageRetentionInDays
        partitionCount: partitionCount
        status: 'Active'
    }
}

resource consumergroups 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2022-01-01-preview' = [for group in consumerGroups:{
    name: '${group}'
    properties: {}
    parent:hub
}]

resource rules 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2022-01-01-preview' = [for rule in items(authorizationRules):{
    name: rule.value.name
    properties: {
        rights:rule.value.rights
    }
    parent:hub
}]

output EventHubId string = resourceId('Microsoft.EventHub/namespaces/eventhubs', namespaceName, name)
