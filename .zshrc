# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf-tab)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


### jerpint settings

# Set vim keybindings
bindkey -v

# Source aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Spawn terminal with tmux
if [ "$TMUX" = "" ]; then tmux; fi

bindkey '^R' history-incremental-search-backward

# Remove computer name from prompt
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# heroku autocomplete setup
# HEROKU_AC_ZSH_SETUP_PATH=/Users/jeremypinto/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;source /opt/homebrew/opt/chruby/share/chruby/chruby.sh

# Set for starship
# conda config --set changeps1 False
# eval "$(starship init zsh)"

# Ruby
# source /opt/homebrew/opt/chruby/share/chruby/auto.sh
# chruby ruby-3.1.2


# node (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


function pdf() {
  # takes a .csv file, and imports it to pandas directly in ipython
  if [ $# -ne 1 ]; then
    echo "Usage: df <path_to_csv>"
    return 1
  fi

  csv_file=$1

  if [ ! -f "$csv_file" ]; then
    echo "File not found: $csv_file"
    return 1
  fi

  ipython -c "import pandas as pd; df = pd.read_csv('$csv_file'); import IPython; IPython.embed()"
}


function ccd() {
    cd "$HOME/$1"
}

# ship: Creates a worktree based off an up-to-date main branch and runs claude /ship
# Ensures main is synced with origin/main before creating the worktree
# Usage: ship <branch-name>
# Example: ship feature/new-login
ship() {
    local branch_name=""

    # Color codes
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m'

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                echo "Usage: ship <branch-name>"
                echo ""
                echo "Creates a worktree for the branch (based off main) and runs 'claude /ship --permission-mode acceptEdits'"
                return 0
                ;;
            *)
                branch_name="$1"
                shift
                ;;
        esac
    done

    # Check if branch name is provided
    if [ -z "$branch_name" ]; then
        echo -e "${RED}Error: Branch name is required${NC}"
        echo "Usage: ship <branch-name>"
        return 1
    fi

    # Check if we're in a git repository
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -z "$git_root" ]; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        return 1
    fi

    # Fetch latest changes from remote
    echo -e "${YELLOW}Fetching latest changes from remote...${NC}"
    git fetch origin

    # Check if main branch exists locally
    if ! git show-ref --verify --quiet refs/heads/main; then
        echo -e "${RED}Error: main branch does not exist locally${NC}"
        return 1
    fi

    # Check if local main is up to date with remote
    local local_main=$(git rev-parse main)
    local remote_main=$(git rev-parse origin/main)

    if [ "$local_main" != "$remote_main" ]; then
        echo -e "${YELLOW}Local main is not up to date with origin/main${NC}"
        echo -e "${YELLOW}Updating main branch...${NC}"

        # Store current branch
        local current_branch=$(git rev-parse --abbrev-ref HEAD)

        # Update main
        git checkout main
        git pull origin main

        # Return to original branch if it wasn't main
        if [ "$current_branch" != "main" ]; then
            git checkout "$current_branch"
        fi

        echo -e "${GREEN}✓ Main branch updated${NC}"
    else
        echo -e "${GREEN}✓ Main branch is up to date${NC}"
    fi

    # Convert slashes to hyphens for the folder name
    local folder_name="${branch_name//\//-}"
    local worktree_path="$git_root/../worktrees/$folder_name"

    echo -e "${GREEN}Creating worktree for branch: ${branch_name} (based off main)${NC}"

    # Check if branch exists locally
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo -e "${YELLOW}Branch exists locally, checking out existing branch${NC}"
        git worktree add "$worktree_path" "$branch_name"
    # Check if branch exists on remote
    elif git ls-remote --heads origin "$branch_name" 2>/dev/null | grep -q "$branch_name"; then
        echo -e "${YELLOW}Branch exists on remote, creating local branch from remote${NC}"
        git worktree add "$worktree_path" -b "$branch_name" "origin/$branch_name"
    # Create new branch based off main
    else
        echo -e "${YELLOW}Branch doesn't exist, creating new branch based off main${NC}"
        git worktree add "$worktree_path" -b "$branch_name" main
    fi

    # Only proceed if worktree was created successfully
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Worktree created successfully!${NC}"
        echo -e "Changing directory to: ${worktree_path}"
        cd "$worktree_path"

        echo ""
        echo -e "${GREEN}Running: claude /ship --permission-mode acceptEdits${NC}"
        claude /ship --permission-mode acceptEdits
    else
        echo -e "${RED}✗ Failed to create worktree${NC}"
        return 1
    fi
}

worktree() {
    local branch_name=""
    local create_pr=false

    # Color codes
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m'

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --branch|-b)
                branch_name="$2"
                shift 2
                ;;
            --pr)
                create_pr=true
                shift
                ;;
            --help|-h)
                echo "Usage: worktree <branch-name> [--pr]"
                echo "   or: worktree --branch <branch-name> [--pr]"
                echo ""
                echo "Creates a git worktree and automatically cd's into it"
                echo ""
                echo "Options:"
                echo "  --pr    Create a draft pull request on GitHub"
                return 0
                ;;
            *)
                branch_name="$1"
                shift
                ;;
        esac
    done

    # Check if branch name is provided
    if [ -z "$branch_name" ]; then
        echo -e "${RED}Error: Branch name is required${NC}"
        echo "Usage: worktree <branch-name> [--pr]"
        echo "   or: worktree --branch <branch-name> [--pr]"
        return 1
    fi

    # Check if we're in a git repository
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -z "$git_root" ]; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        return 1
    fi

    # Convert slashes to hyphens for the folder name
    local folder_name="${branch_name//\//-}"
    local worktree_path="$git_root/../worktrees/$folder_name"

    echo -e "${GREEN}Creating worktree for branch: ${branch_name}${NC}"

    # Check if branch exists locally
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo -e "${YELLOW}Branch exists locally, checking out existing branch${NC}"
        git worktree add "$worktree_path" "$branch_name"
    # Check if branch exists on remote
    elif git ls-remote --heads origin "$branch_name" 2>/dev/null | grep -q "$branch_name"; then
        echo -e "${YELLOW}Branch exists on remote, creating local branch from remote${NC}"
        git worktree add "$worktree_path" -b "$branch_name" "origin/$branch_name"
    # Create new branch
    else
        echo -e "${YELLOW}Branch doesn't exist, creating new branch${NC}"
        git worktree add "$worktree_path" -b "$branch_name"
    fi

    # Only cd if worktree was created successfully
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Worktree created successfully!${NC}"
        echo -e "Changing directory to: ${worktree_path}"
        cd "$worktree_path"

        # Create PR if requested
        if [ "$create_pr" = true ]; then
            echo ""
            echo -e "${YELLOW}Creating draft pull request...${NC}"

            # Check if gh CLI is installed
            if ! command -v gh &> /dev/null; then
                echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
                echo "Install it with: brew install gh"
                return 1
            fi

            # Push the branch first (required for PR)
            git push -u origin "$branch_name" 2>/dev/null || true

            # Create draft PR
            gh pr create --draft --title "$branch_name" --body "" --head "$branch_name"

            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ Draft PR created!${NC}"
            else
                echo -e "${RED}✗ Failed to create PR${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ Failed to create worktree${NC}"
        return 1
    fi
}

worktree-rm() {
    local branch_name=""
    local delete_branch=false
    local force=false
    local clean_all=false

    # Color codes
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m'

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --branch|-b)
                branch_name="$2"
                shift 2
                ;;
            --delete-branch|-d)
                delete_branch=true
                shift
                ;;
            --force|-f)
                force=true
                shift
                ;;
            --clean-all|-a)
                clean_all=true
                shift
                ;;
            --help|-h)
                echo "Usage: worktree-rm <branch-name> [options]"
                echo "       worktree-rm --clean-all [options]"
                echo ""
                echo "Removes a git worktree and optionally deletes the local branch"
                echo ""
                echo "Options:"
                echo "  -a, --clean-all        Remove ALL worktrees for current repo"
                echo "  -d, --delete-branch    Also delete the local branch"
                echo "  -f, --force            Force removal (discard uncommitted changes)"
                echo "  -h, --help             Show this help message"
                return 0
                ;;
            *)
                branch_name="$1"
                shift
                ;;
        esac
    done

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        return 1
    fi

    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    local worktrees_dir="$git_root/../worktrees"

    # Handle --clean-all flag
    if [ "$clean_all" = true ]; then
        echo -e "${YELLOW}Removing all worktrees for current repository...${NC}"
        echo ""

        local count=0
        local failed=0

        # Get list of worktrees for this repo (excluding the main worktree)
        git worktree list --porcelain | while IFS= read -r line; do
            if [[ $line == worktree* ]]; then
                local worktree_path="${line#worktree }"

                # Skip the main worktree (git_root)
                if [ "$worktree_path" = "$git_root" ]; then
                    continue
                fi

                # Extract branch name from the path
                local folder_name=$(basename "$worktree_path")
                local branch="${folder_name//-//}"

                echo -e "${YELLOW}Removing: ${branch}${NC}"
                echo -e "  Path: ${worktree_path}"

                # Remove worktree
                if [ "$force" = true ]; then
                    git worktree remove --force "$worktree_path"
                else
                    git worktree remove "$worktree_path"
                fi

                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✓ Removed${NC}"

                    # Delete local branch if requested
                    if [ "$delete_branch" = true ]; then
                        if git show-ref --verify --quiet "refs/heads/$branch"; then
                            git branch -d "$branch" 2>/dev/null || git branch -D "$branch"
                            echo -e "${GREEN}  ✓ Local branch deleted${NC}"
                        fi
                    fi
                else
                    echo -e "${RED}✗ Failed${NC}"
                fi
                echo ""
            fi
        done

        # Count results after the loop
        local total_worktrees=$(git worktree list | wc -l)
        local remaining_worktrees=$(git worktree list | wc -l)

        echo -e "${GREEN}Cleanup complete!${NC}"
        echo "Remaining worktrees: $remaining_worktrees (including main)"

        return 0
    fi

    # Check if branch name is provided
    if [ -z "$branch_name" ]; then
        echo -e "${RED}Error: Branch name is required${NC}"
        echo "Usage: worktree-rm <branch-name> [--delete-branch] [--force]"
        echo "       worktree-rm --clean-all [options]"
        echo ""
        echo "Available worktrees for this repository:"
        git worktree list
        return 1
    fi

    # Convert slashes to hyphens for the folder name
    local folder_name="${branch_name//\//-}"
    local worktree_path="$worktrees_dir/$folder_name"

    # Check if worktree exists
    if [ ! -d "$worktree_path" ]; then
        echo -e "${RED}Error: Worktree not found at $worktree_path${NC}"
        echo ""
        echo "Available worktrees for this repository:"
        git worktree list
        return 1
    fi

    echo -e "${YELLOW}Removing worktree: ${branch_name}${NC}"

    # Remove worktree
    if [ "$force" = true ]; then
        git worktree remove --force "$worktree_path"
    else
        git worktree remove "$worktree_path"
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Worktree removed successfully!${NC}"

        # Delete local branch if requested
        if [ "$delete_branch" = true ]; then
            echo ""
            echo -e "${YELLOW}Deleting local branch: ${branch_name}${NC}"

            if git show-ref --verify --quiet "refs/heads/$branch_name"; then
                git branch -d "$branch_name" 2>/dev/null || git branch -D "$branch_name"
                echo -e "${GREEN}✓ Local branch deleted${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ Failed to remove worktree${NC}"
        echo "Tip: Use --force to discard uncommitted changes"
        return 1
    fi
}


# register this function for autocompletion with the ccd command using the complete builtin:
# complete -F _ccd ccd
function _ccd() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls -d $HOME/*/ | xargs -n 1 basename)" -- $cur) )
}
complete -F _ccd ccd


# . "$HOME/.cargo/env"

# Added by LM Studio CLI (lms)
# export PATH="$PATH:/Users/jeremypinto/.lmstudio/bin"

# UV Autocompletion
eval "$(uv generate-shell-completion zsh)"

# Fix completions for uv run.
_uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
        _arguments '*:filename:_files'
    else
        _uv "$@"
    fi
}
compdef _uv_run_mod uv

# Better history
HISTSIZE=10000
HISTFILESIZE=20000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Ruby
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"

export EDITOR=vim
export VISUAL=vim

# nvm use 24.8.0
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/jerpint/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jerpint/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/jerpint/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jerpint/google-cloud-sdk/completion.zsh.inc'; fi

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  # elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
  #   echo "Reverting to nvm default version"
  #   nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
# source ~/.config/op/plugins.sh
