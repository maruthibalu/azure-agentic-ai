param openAiName string
param location string

resource openai 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: openAiName
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: openAiName
  }
}

output openaiEndpoint string = openai.properties.endpoint
output openaiId string = openai.id
