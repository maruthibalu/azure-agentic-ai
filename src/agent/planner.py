import os
import openai

openai.api_type = "azure"
openai.api_base = os.environ["AZURE_OPENAI_ENDPOINT"]
openai.api_version = "2024-05-01-preview"
openai.api_key = os.environ["AZURE_OPENAI_KEY"]

def plan(user_input: str):
    """Ask Azure OpenAI to decide which tool(s) to call."""
    system_prompt = """You are a planner. 
    Map user requests to JSON tool calls.
    Tools: create_vm(resourceGroup, name, region, size, image),
           create_storage(resourceGroup, name, region).
    """

    resp = openai.ChatCompletion.create(
        engine=os.environ["AZURE_OPENAI_DEPLOYMENT"],
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_input}
        ],
        temperature=0
    )
    
    # Expect JSON in assistant reply
    steps = eval(resp["choices"][0]["message"]["content"])
    return steps
