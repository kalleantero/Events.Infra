targetScope = 'subscription'

param location string
param tags object
param eventsResourceGroupName string

var servicePrefix = 'events'
var rgScope = resourceGroup(eventsResourceGroupName)
var resourceToken = toLower(uniqueString(subscription().id, 'events', location))
var abbreviations = loadJsonContent('assets/abbreviations.json')

module resourceGroupEvents './modules/resourceGroup.bicep' = {
  name:eventsResourceGroupName
  params:{
      location:location
      name:eventsResourceGroupName
      tags:tags
  }
}

var topicName = '${abbreviations.eventGridTopic}${servicePrefix}-${location}-${resourceToken}'

module evgtTopic './modules/eventGridTopic.bicep' = {
  name:topicName
  params:{
    location:location
    name:topicName
    tags: tags
  }
  dependsOn:[
      resourceGroupEvents
  ]
  scope:rgScope
}

var logAnalyticsWorkspaceName = '${abbreviations.logAnalyticsWorkspace}${servicePrefix}-${location}-${resourceToken}'

module logAnalyticsWorkspace 'modules/logAnalyticsWorkspace.bicep' = {
  name: logAnalyticsWorkspaceName
  params:{
    name: logAnalyticsWorkspaceName
    tags:tags
    location:location
  }
  dependsOn:[
    resourceGroupEvents
  ]
  scope:rgScope
}

var applicationInsightsName  = '${abbreviations.applicationInsights}${servicePrefix}-${location}-${resourceToken}'

module applicationInsights 'modules/applicationInsights.bicep' = {
  name: applicationInsightsName
  params:{
    name: applicationInsightsName
    tags:tags
    location:location
    workspaceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
  }
  scope:rgScope
  dependsOn:[
    logAnalyticsWorkspace
    resourceGroupEvents
  ]
}

var appServicePlanName = '${abbreviations.appServicePlan}${servicePrefix}-${location}-${resourceToken}'

module appServicePlan 'modules/appServicePlan.bicep' = {
  name: appServicePlanName
  params:{
    name: appServicePlanName
    sku: 'B1'
    kind: 'app,windows'
    tags: tags
    location: location
  }
  dependsOn:[
    resourceGroupEvents
  ]
  scope:rgScope
}

var keyVaultName = '${abbreviations.keyVault}${servicePrefix}-${resourceToken}'

module keyVault 'modules/keyVault.bicep' = {
  name: keyVaultName
  scope: rgScope
  params:{
    name: keyVaultName
    tags: tags
    location: location
    sku: 'Standard'
    objectId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn:[
    resourceGroupEvents
  ]
}

var functionAppName = '${abbreviations.functionsApp}${servicePrefix}-${location}-${resourceToken}'
var storageAccountName = '${abbreviations.storageAccount}${resourceToken}'
var functionKeySecretName = 'webhook-function-key'

module functionApp 'modules/azureFunction.bicep' = {
  name: functionAppName
  params:{
    functionName: functionAppName
    storageAccountName: storageAccountName
    location: location
    tags: tags
    serverfarmId: appServicePlan.outputs.appServicePlanId
    instrumentationKey: applicationInsights.outputs.applicationInsightsInstrumentationKey
    keyVaultName: keyVault.name
    functionKeySecretName: functionKeySecretName
  }
  scope:rgScope
  dependsOn:[
    resourceGroupEvents
    appServicePlan
    applicationInsights
    keyVault
  ]
}
