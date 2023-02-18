# Create Azure Infrastructure (Bicep) for Event Grid and Webhook event handler

This repository contains a sample how to create a Azure Infrastructure (Bicep) for Event Grid and Webhook event handler. This sample is related to blog post published in my blog (see links below).


## Deployment

Webhook application must be deployed before event handler (subscription) is possible to configure in Event Grid. 

![eventgrid-high-level](https://user-images.githubusercontent.com/11143214/219687338-8d773da1-50f4-46ac-a031-e66edbaf438c.png)

1) Execute Azure Core Infrastructure deployment
```
az deployment sub create -f coreInfrastructure.bicep --location westeurope
```
2) Deploy Webhook application

3) Execute Azure Core Infrastructure Post-Deployment
```
az deployment sub create -f postDeploymentCoreInfrastructure.bicep --location westeurope
```
## Used technologies
- Bicep

## Read more
- Blog posts
  - [How to create an infrastructure for EventGrid and Webhook event handler?](https://www.kallemarjokorpi.fi/blog/how-to-create-infrastructure-for-eventgrid-and-webhook.html)

