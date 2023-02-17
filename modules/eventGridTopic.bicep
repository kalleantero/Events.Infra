param location string = resourceGroup().location
param name string
param tags object

resource topic 'Microsoft.EventGrid/topics@2022-06-15' = {
    name:name
    location:location
    tags: tags
    identity:{
	    type:'SystemAssigned'
    }
    properties: {
        inputSchema:'CloudEventSchemaV1_0'
        publicNetworkAccess:'Enabled'
        inboundIpRules:[]
        disableLocalAuth:false
        dataResidencyBoundary:'WithinGeopair'
    }
}

output PrincipalId string = topic.identity.principalId
