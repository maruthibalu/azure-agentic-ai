param appInsightsName string
param location string

resource ai 'microsoft.insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output appInsightsId string = ai.id
output appInsightsKey string = ai.properties.InstrumentationKey
