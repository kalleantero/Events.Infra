param subscriptionName string
param topicName string
param webhookEndpointUrl string
@secure()
param functionKey string
param eventTimeToLiveInMinutes int
param maxDeliveryAttempts int
param maxEventsPerBatch int
param preferredBatchSizeInKilobytes int

resource subscription 'Microsoft.EventGrid/topics/eventSubscriptions@2022-06-15' = {
    name:'${topicName}/${subscriptionName}'
    properties: {
        filter:{
	        enableAdvancedFilteringOnArrays:true
        }
        labels:[]
        eventDeliverySchema:'CloudEventSchemaV1_0'
        retryPolicy:{
	        eventTimeToLiveInMinutes:eventTimeToLiveInMinutes
            maxDeliveryAttempts:maxDeliveryAttempts
        }
        destination:{
	        endpointType: 'WebHook'
            properties:{
                maxEventsPerBatch:maxEventsPerBatch
                preferredBatchSizeInKilobytes:preferredBatchSizeInKilobytes
                endpointUrl: '${webhookEndpointUrl}?code=${functionKey}'
            }         
        }
    }
}
