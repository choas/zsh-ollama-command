# default shortcut as Ctrl-o
(( ! ${+ZSH_OLLAMA_COMMANDS_HOTKEY} )) && typeset -g ZSH_OLLAMA_COMMANDS_HOTKEY='^o'
# default ollama model as llama3.1
(( ! ${+ZSH_OLLAMA_MODEL} )) && typeset -g ZSH_OLLAMA_MODEL='llama3.1'
# default response number as 5
(( ! ${+ZSH_OLLAMA_COMMANDS} )) && typeset -g ZSH_OLLAMA_COMMANDS='5'
# default ollama server host
(( ! ${+ZSH_OLLAMA_URL} )) && typeset -g ZSH_OLLAMA_URL='http://localhost:11434'

_plugin_dir="${0:h}"

validate_required() {
  # check required tools are installed
  if (( ! $+commands[python3] )) then
      echo "🚨: zsh-ollama-command failed as python3 NOT found!"
      echo "Please install it with 'brew install python3'"
      return 1;
  fi
  if (( ! $+commands[fzf] )) then
      echo "🚨: zsh-ollama-command failed as fzf NOT found!"
      echo "Please install it with 'brew install fzf'"
      return 1;
  fi
  if ! (( $(pgrep -f ollama | wc -l ) > 0 )); then
    echo "🚨: zsh-ollama-command failed as OLLAMA server NOT running!"
    echo "Please start it with 'brew services start ollama'"
    return 1;
  fi
  if ! curl -s "${ZSH_OLLAMA_URL}/api/tags" | grep -q $ZSH_OLLAMA_MODEL; then
    echo "🚨: zsh-ollama-command failed as model ${ZSH_OLLAMA_MODEL} server NOT found!"
    echo "Please start it with 'ollama pull ${ZSH_OLLAMA_MODEL}' or adjust ZSH_OLLAMA_MODEL"
    return 1;
  fi
}

check_status() {
  tput cuu 1 # cleanup waiting message
  if [ $? -ne 0 ]; then
    echo "༼ つ ◕_◕ ༽つ Sorry! Please try again..."
    exit 1
  fi
}

fzf_ollama_commands() {
  setopt extendedglob
  validate_required
  if [ $? -eq 1 ]; then
    return 1
  fi

  ZSH_OLLAMA_COMMANDS_USER_QUERY=$BUFFER

  zle end-of-line
  zle reset-prompt

  print
  print -u1 "👾Please wait..."

  ZSH_OLLAMA_COMMANDS_SUGGESTION=$($_plugin_dir/ollama.py "$ZSH_OLLAMA_MODEL" "$ZSH_OLLAMA_COMMANDS_USER_QUERY" 4)
  check_status

  tput cuu 1 # cleanup waiting message

  # check if ZSH_OLLAMA_COMMANDS_USER_QUERY starts with a ?
  if [[ $ZSH_OLLAMA_COMMANDS_USER_QUERY == \?* ]]; then
    ZSH_OLLAMA_COMMANDS_SELECTED=$(echo "$ZSH_OLLAMA_COMMANDS_SUGGESTION")
  else
    ZSH_OLLAMA_COMMANDS_SELECTED=$(echo $ZSH_OLLAMA_COMMANDS_SUGGESTION | fzf --ansi --height=~10 --cycle --reverse --border)
  fi
  BUFFER=$ZSH_OLLAMA_COMMANDS_SELECTED

  zle end-of-line
  zle reset-prompt
  return $ret
}

validate_required

autoload fzf_ollama_commands
zle -N fzf_ollama_commands

bindkey $ZSH_OLLAMA_COMMANDS_HOTKEY fzf_ollama_commands
