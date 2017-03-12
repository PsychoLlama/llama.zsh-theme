function llama_git_status {
  local any_changes=$(git status --porcelain)

  if [[ ! -z "$any_changes" ]]; then
    echo "%{$fg[red]%}+"
  fi
}

function llama_branch_name {
  local branch=$(git_current_branch)
  local prompt=""

  # Not a git repo.
  if [[ -z "$branch" ]]; then
    echo " "
    return 0
  fi

  # Prettify the branch name.
  prompt+="%{$fg[yellow]%}["
  prompt+=$(llama_git_status)
  prompt+="%{$fg[cyan]%}$branch"
  prompt+="%{$fg[yellow]%}]"

  echo $prompt
}

function llama_return_status {

  # Turn return status into a color.
  local color="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})"

  # Create a prompt from that color.
  echo "${color}❯ %{$reset_color%}"
}

PROMPT='%{$fg[blue]%}%c$(llama_branch_name)$(llama_return_status)'
