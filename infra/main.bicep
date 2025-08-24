param location string = resourceGroup().location
param openAiName string = 'agent-openai'
param functionAppName string = 'agent-funcapp'
param storageName string = 'agentstorage${uniqueString(resourceGroup().id)}'
param appInsightsName string = 'agent-ai'

module storage './modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    storageName: storageName
    location: location
  }
}

module kv './modules/keyvault.bicep' = {
  name: 'kvDeploy'
  params: {
    location: location
  }
}

module ai './modules/appinsights.bicep' = {
  name: 'aiDeploy'
  params: {
    appInsightsName: appInsightsName
    location: location
  }
}

module openai './modules/openai.bicep' = {
  name: 'openaiDeploy'
  params: {
    location: location
    openAiName: openAiName
  }
}

module func './modules/functionapp.bicep' = {
  name: 'funcDeploy'
  params: {
    functionAppName: functionAppName
    storageAccountId: storage.outputs.storageId
    appInsightsId: ai.outputs.appInsightsId
    location: location
  }
}
