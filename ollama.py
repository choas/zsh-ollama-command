#!/usr/bin/env python3

import http.client
import json

def get_commands(model, query):
    
    conn = http.client.HTTPConnection("localhost", 11434)
    headers = {'Content-Type': 'application/json'}
    body = json.dumps({
        "model": model,
        "messages": [
            {
                "role": "user",
                "content": query
            }
        ],
        "stream": False
    })
    
    conn.request("POST", "/api/chat", body, headers)
    response = conn.getresponse()
    response_json = json.loads(response.read().decode())

    content = response_json['message']['content']

    ### if content contains <think> and </think> tags, remove them and text between them
    while '<think>' in content:
        start = content.index('<think>')
        end = content.index('</think>') + 8
        content = content[:start] + content[end:]

    try:
        commands = [command.strip() for command in content.split('\n') if command.strip()]
        for command in commands:
            print(command)
    except Exception as e:
        raise e

if __name__ == '__main__':
    import sys
    if len(sys.argv) < 4:
        print('Please provide a model, query, and number of commands to return.')
        sys.exit(1)

    if sys.argv[2].startswith('??'):
        sys.argv[2] = sys.argv[2][2:]
        query = f"Explain the following: ${sys.argv[2]}. Reply with the explanation. Do not include any additional text in the response. Provide only one response."
    elif sys.argv[2].startswith('?'):
        sys.argv[2] = sys.argv[2][1:]
        query = f"Explain the following macOS command: ${sys.argv[2]}. Reply with the explanation. Do not include any additional text in the response. Provide only one response."
    else:
        print(sys.argv[2])
        query = f"Seek for macOS terminal commands (zsh shell) for the following task: ${sys.argv[2]}. Reply each command in a new line. Response only the commands, no any additional description,  formating, or markdown. No additional text should be present in each entry and commands, remove empty string entry. Each string entry should be a new string entry. If the task need more than one command, combine them in one string entry. Each string entry should only contain the command(s). Do not include empty entry. Provide multiple entry (at most {sys.argv[3]} relevant entry)."

    get_commands(sys.argv[1], query)
