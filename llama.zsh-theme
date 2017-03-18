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
