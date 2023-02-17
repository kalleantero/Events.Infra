targetScope = 'subscription'

param location string
param eventsResourceGroupName string

var servicePrefix = 'events'
var rgScope = resourceGroup(eventsResourceGroupName)
var resourceToken = toLower(uniqueString(subscription().id, 'events', location))
var abbreviations = loadJsonContent('assets/abbreviations.json')

var topicName = '${abbreviations.eventGridTopic}${servicePrefix}-${location}-${resourceToken}'

var keyVaultName = '${abbreviations.keyVault}${servicePrefix}-${resourceToken}'
var functionAppName = '${abbreviations.functionsApp}${servicePrefix}-${location}-${resourceToken}'
var functionKeySecretName = 'webhook-function-key'

resource functionApp 'Microsoft.Web/sites@2021-03-01' existing = {
  name: functionAppName
  scope: rgScope
}

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
  scope: rgScope
}

var eventGridSubscriptionName = '${abbreviations.eventGridSubscription}${servicePrefix}-${location}-${resourceToken}'
var webhookFunctionPath = '/api/Function1'

module eventGridWebhookSubscriber 'modules/eventGridWebhookSubscription.bicep' = {
  scope:rgScope
  name: eventGridSubscriptionName
  params: {
    topicName: topicName
    subscriptionName: eventGridSubscriptionName
    eventTimeToLiveInMinutes: 1440
    maxDeliveryAttempts: 30
    maxEventsPerBatch: 1
    preferredBatchSizeInKilobytes: 64
    webhookEndpointUrl: 'https://${functionApp.properties.defaultHostName}/${webhookFunctionPath}'
    functionKey: kv.getSecret(functionKeySecretName)
  }
}

