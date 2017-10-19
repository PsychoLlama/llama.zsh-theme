#!/usr/bin/env zsh

function llama_git_status {
  local unstaged_changes="$(git ls-files --others --modified --exclude-standard)"
  local staged_changes="$(git diff --name-only --cached)"

  if [[ ! -z "$unstaged_changes" ]] && [[ ! -z "$staged_changes" ]]; then
    echo "%{$fg[yellow]%}+"
  elif [[ ! -z "$unstaged_changes" ]]; then
    echo "%{$fg[red]%}+"
  elif [[ ! -z "$staged_changes" ]]; then
    echo "%{$fg[green]%}+"
  fi
}

function llama_venv_status {
  if [[ -z "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    return
  fi

  if [[ -z "$VIRTUAL_ENV" ]]; then
    return
  fi

  title="%{$fg[cyan]%}$(basename "$VIRTUAL_ENV")"

  if [[ ! -z "$1" ]]; then
    title="%{$fg[yellow]%}($title%{$fg[yellow]%})"
  fi

  echo "$title"
}

function llama_branch_status {
  local branch="$(git_current_branch)"

  # It's a git repo.
  if [[ ! -z "$branch" ]]; then
    local prompt

    prompt+=$(llama_git_status)
    prompt+="%{$fg[cyan]%}$branch"

    echo "$prompt"
  fi
}

function llama_tool_summary {
  local branch="$(llama_branch_status)"
  local venv="$(llama_venv_status "$branch")"

  if [[ -z "$branch" ]] && [[ -z "$venv" ]]; then
    echo " "
    return
  fi

  local prompt
  local delimiter=('[' ']')

  if [[ -z "$branch" ]] && [[ ! -z "$venv" ]]; then
    delimiter=('(' ')')
  fi

  prompt+="%{$fg[yellow]%}${delimiter[1]}"
  prompt+="$branch"
  prompt+="$venv"
  prompt+="%{$fg[yellow]%}${delimiter[2]}"

  echo "$prompt"
}

function llama_return_status {

  # Turn return status into a color.
  local color="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})"

  # Create a prompt from that color.
  echo "${color}❯ %{$reset_color%}"
}

function llama_prompt {
  local prompt

  prompt+="$(llama_tool_summary)"
  prompt+="$(llama_return_status)"

  echo "$prompt"
}

export PS1='%{$fg[blue]%}%c$(llama_prompt)'
