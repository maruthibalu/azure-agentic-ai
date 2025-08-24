param functionAppName string
param storageAccountId string
param appInsightsId string
param location string

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  id: storageAccountId
}

resource ai 'microsoft.insights/components@2020-02-02' existing = {
  id: appInsightsId
}

resource plan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${functionAppName}-plan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource func 'Microsoft.Web/sites@2023-01-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        { name: "APPINSIGHTS_INSTRUMENTATIONKEY", value: ai.properties.InstrumentationKey }
        { name: "AzureWebJobsStorage", value: sa.properties.primaryEndpoints.blob }
      ]
    }
  }
}
