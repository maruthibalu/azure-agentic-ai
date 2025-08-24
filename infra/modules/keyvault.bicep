param location string
param kvName string = 'agent-kv${uniqueString(resourceGroup().id)}'

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: kvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [] // Access policies will be managed with RBAC (recommended)
    enableRbacAuthorization: true
  }
}

output kvId string = kv.id
output kvName string = kv.name
