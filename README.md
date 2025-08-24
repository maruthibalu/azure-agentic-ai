# Azure Agentic AI

This repository contains an agentic AI system designed to work with Azure services. It includes infrastructure as code (Bicep), Python modules for agent orchestration, authentication, cost management, and tools for resource creation.

## Structure
- `infra/`: Bicep files for Azure resources
- `src/agent/`: Agent logic and prompts
- `src/common/`: Shared utilities (auth, logging, cost guard)
- `src/orchestrator/`: Main orchestration logic
- `src/tools/`: Scripts for Azure resource creation
- `src/tests/`: Unit tests

## Getting Started
1. Clone the repository
2. Install dependencies: `pip install -r requirements.txt`
3. Configure local settings in `local.settings.json`
4. Deploy infrastructure using Bicep files in `infra/`

## Deployment in detail
1. Deploy infra (all modules wired by main.bicep)
az deployment group create \
  -g my-agent-rg \
  -f infra/main.bicep \
  -p location=eastus

2. Assign RBAC to Function App’s managed identity
FUNC_ID=$(az webapp show -g my-agent-rg -n agent-funcapp --query identity.principalId -o tsv)

# Allow Function to use Key Vault
az role assignment create --assignee $FUNC_ID \
  --role "Key Vault Secrets User" \
  --scope $(az keyvault show -n <your-kv-name> -g my-agent-rg --query id -o tsv)

# Allow Function to manage VMs & Storage in the RG
az role assignment create --assignee $FUNC_ID \
  --role "Contributor" \
  --scope $(az group show -n my-agent-rg --query id -o tsv)

3. Deploy Function code
func azure functionapp publish agent-funcapp

4. Test agent
curl -X POST https://agent-funcapp.azurewebsites.net/api/main \
  -H "Content-Type: application/json" \
  -d '{"query":"Create a VM in East US with size Standard_B1s"}'



## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
MIT
