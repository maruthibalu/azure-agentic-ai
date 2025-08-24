import azure.functions as func
from ..agent.planner import plan
from ..tools import create_vm, create_storage

def main(req: func.HttpRequest) -> func.HttpResponse:
    user_input = req.get_json().get("query")
    
    # Get plan from Azure OpenAI
    steps = plan(user_input)

    results = []
    for step in steps:
        if step["tool"] == "create_vm":
            result = create_vm.run(step["args"])
        elif step["tool"] == "create_storage":
            result = create_storage.run(step["args"])
        else:
            result = {"error": f"Unknown tool {step['tool']}"}
        results.append(result)

    return func.HttpResponse(str(results), status_code=200)
