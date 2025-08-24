from azure.identity import DefaultAzureCredential
from azure.mgmt.storage import StorageManagementClient

def run(args):
    cred = DefaultAzureCredential()
    subscription_id = args.get("subscriptionId")
    client = StorageManagementClient(cred, subscription_id)

    rg = args["resourceGroup"]
    account_name = args["name"]

    params = {
        "sku": {"name": "Standard_LRS"},
        "kind": "StorageV2",
        "location": args["region"],
    }

    poller = client.storage_accounts.begin_create(rg, account_name, params)
    return poller.result().as_dict()
