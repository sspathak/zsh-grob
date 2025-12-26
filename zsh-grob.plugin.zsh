# ------------------------------------------------------------------------------
# zsh-grob: Interactive git rebase --onto helper
# ------------------------------------------------------------------------------

grob() {
  # Dependency check
  if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: 'fzf' is not installed. Please install it to use grob."
    return 1
  fi

  # Capture all flags passed to the function
  local extra_flags=("$@")

  # Text formatting
  local bold=$(tput bold)
  local reset=$(tput sgr0)
  local blue=$(tput setaf 4)
  local green=$(tput setaf 2)
  local yellow=$(tput setaf 3)
  local red=$(tput setaf 1)
  local cyan=$(tput setaf 6)
  local mag=$(tput setaf 5)
  local dim=$(tput setaf 8)

  # Check for dirty worktree
  if ! git diff-index --quiet HEAD --; then
    echo "${yellow}⚠️  Warning: Uncommitted changes detected. Please stash or commit first.${reset}"
    return 1
  fi

  # 1. Select Target Branch
  local target_branch=$(git branch --format='%(refname:short)' | \
    fzf --height 60% --border --prompt="onto ➜ " \
        --header="STEP 1: Select TARGET branch" \
        --preview-window=up:40% \
        --preview 'git log --oneline --graph --color=always -n 15 {}')
  
  [[ -z "$target_branch" ]] && return

  # 2. Select Oldest Commit 
  local header_text="TARGET: [${bold}${green}${target_branch}${reset}]"$'\n'"STEP 2: Select the OLDEST commit to move (includes selection + all newer)"

  local preview_cmd='
    git show --format="%C(yellow)%h%C(reset) %C(magenta)%an%C(reset) %C(cyan)(%ad)%C(reset)%n%s" --date=format:"%b %d, %Y" --color=always {1} | head -n 2;
    echo "";
    git diff --shortstat {1}^ {1} | awk "{
      gsub(/[0-9]+/, \"\033[33m&\033[0m\");
      gsub(/insertion/, \"\033[32minsertion\033[0m\");
      gsub(/deletion/, \"\033[31mdeletion\033[0m\");
      print
    }";
    echo "";
    git show --stat --format="" --color=always {1} | sed \"\$d\";
    echo "";
    echo "'"$(tput setaf 8)"'──────────────────────────────────────────────────'"$reset"'";
    git show -s --format="%C(bold)Full SHA:%C(reset) %H%n%C(bold)Author:%C(reset)   %ae%n%C(bold)Commit:%C(reset)   %ad" --date=format:"%b %d, %Y %H:%M:%S" {1}'

  local selection=$(git log --oneline --color=always | \
    fzf --ansi --height 60% --border \
        --prompt="move from ➜ " \
        --header="$header_text" \
        --preview-window=up:6 \
        --preview "$preview_cmd")
  
  [[ -z "$selection" ]] && return

  # Extract hash and calculate distance
  local commit_hash=$(echo "$selection" | awk "{print \$1}")
  local commit_index=$(git log --oneline | grep -nF "$commit_hash" | cut -d: -f1)
  local base_ref="HEAD~$commit_index"

  # 3. Classic Confirmation UI
  echo "\n${bold}${cyan}REBASE PREVIEW${reset}"
  echo "${dim}====================================================${reset}"
  printf "  %-18s %s\n" "${bold}Target Branch:${reset}" "${green}${target_branch}${reset}"
  printf "  %-18s %s\n" "${bold}Commit Count :${reset}"  "${yellow}${commit_index} commit(s)${reset}"
  printf "  %-18s %s\n" "${bold}Starting At  :${reset}"   "${mag}${commit_hash}${reset}"
  
  # Only show Extra Flags if they exist
  if [[ ${#extra_flags[@]} -gt 0 ]]; then
    printf "  %-18s %s\n" "${bold}Extra Flags  :${reset}"   "${blue}${extra_flags[*]}${reset}"
  fi

  echo "${dim}----------------------------------------------------${reset}"
  echo "  ${bold}Command:${reset} ${dim}git rebase --onto $target_branch $base_ref ${extra_flags[*]}${reset}"
  echo "${dim}====================================================${reset}\n"

  echo -n "  Confirm execution? (y/N): "
  read -k 1 confirm
  echo "\n" 

  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "${green}Executing rebase...${reset}"
    git rebase --onto "$target_branch" "$base_ref" "${extra_flags[@]}"
  else
    echo "${dim}Aborted.${reset}"
  fi
}
