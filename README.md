# zsh-ollama-command

An [`oh-my-zsh`](https://ohmyz.sh) plugin that integrates the Ollama AI model
with [fzf](https://github.com/junegunn/fzf) to provide intelligent command
suggestions based on user input requirements.

Experience the power of AI-driven command suggestions in your MacOS terminal! This
plugin is perfect for developers, system administrators, and anyone looking to
streamline their workflow.

## Features

* **Intelligent Command Suggestions**: Use Ollama to generate relevant MacOS
  terminal commands based on your query or input requirement.
* **FZF Integration**: Interactively select suggested commands using FZF's fuzzy
  finder, ensuring you find the right command for your task.
* **Customizable**: Configure default shortcut, Ollama model, and response number
  to suit your workflow.

## Requirements

* `python3` for API requests and parsing JSON responses
* `fzf` for interactive selection of commands
* [`ollama`](https://ollama.com/) server running

## Configuration Variables

| Variable Name                | Default Value            | Description                                    |
|------------------------------|--------------------------|------------------------------------------------|
| `ZSH_Ollama_MODEL`           | `llama3.1`               | Ollama model to use (e.g., `llama3.1`)         |
| `ZSH_Ollama_COMMANDS_HOTKEY` | `Ctrl-o`                 | Default shortcut key for triggering the plugin |
| `ZSH_Ollama_COMMANDS`        | 5                        | Number of command suggestions displayed        |
| `ZSH_Ollama_URL`             | `http://localhost:11434` | The URL of Ollama server host                  |

## Usage

1. Clone the repository to `oh-my-zsh` custom plugin folder

    ```bash
    git clone https://github.com/choas/zsh-ollama-command.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-ollama-command
    ```

2. Enable the plugin in ~/.zshrc:

    ```bash
    plugins=(
      [plugins...]
      zsh-ollama-command
    )
    ```

3. Input what you want to do then trigger the plugin. Press the custom shortcut (default is Ctrl-o) to start
   the command suggestion process.

4. Interact with FZF: Type a query or input requirement, and FZF will display
   suggested MacOS terminal commands. Select one to execute.
