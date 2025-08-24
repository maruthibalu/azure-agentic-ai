from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient

def run(args):
    cred = DefaultAzureCredential()
    subscription_id = args.get("subscriptionId")
    client = ComputeManagementClient(cred, subscription_id)

    rg = args["resourceGroup"]
    vm_name = args["name"]

    vm_params = {
        "location": args["region"],
        "hardware_profile": {"vm_size": args["size"]},
        "storage_profile": {
            "image_reference": {
                "publisher": "Canonical",
                "offer": "UbuntuServer",
                "sku": args["image"],
                "version": "latest"
            }
        },
        "os_profile": {
            "computer_name": vm_name,
            "admin_username": args["adminUsername"],
            "admin_password": args["adminPassword"]
        },
        "network_profile": {
            "network_interfaces": [{"id": args["nicId"]}]
        }
    }

    poller = client.virtual_machines.begin_create_or_update(rg, vm_name, vm_params)
    return poller.result().as_dict()
