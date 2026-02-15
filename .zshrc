# Enable Powerlevel10k instant prompt. Should stay close to the top.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# === Oh My Zsh Setup ===
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_MAGIC_FUNCTIONS="true" # Fix paste issues
plugins=(git)

source $ZSH/oh-my-zsh.sh

# === Environment & Path ===
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"
export PGUSER=epic_dev
export GOPATH=$HOME/go
 
typeset -U path
path=(
    "$HOME/.config/nvim"
    "/opt/mssql-tools18/bin"
    "/usr/local/go/bin"
    "$GOPATH/bin"
    $path
)
export PATH

# === Tools & Integrations ===
# Zoxide (Better cd)
export _ZO_ECHO='1'
export _ZO_EXCLUDE_DIRS="$HOME/tmp:~/code/old"
eval "$(zoxide init zsh)"

# FZF Configuration
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# Syntax & Autosuggestions (Load these last-ish)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load P10k Config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# === Aliases ===
# General
alias ee="eza -lah --icons"
alias nf='nvim $(fzf)'
alias tbc='tldr "$@" | batcat --paging=never --color=always'

# Dev Tools
alias mssql='sqlcmd -S localhost -U sa -C'
alias dc="docker compose"

# Docker Power Management
alias d-wake="sudo systemctl start docker && echo '🐳 Docker is Awake'"
alias d-sleep="sudo systemctl stop docker && echo '💤 Docker is Asleep'"
alias d-status="systemctl status docker --no-pager"

# Custom Functions
function fzfb() {
  fzf --preview "batcat --color=always --style=numbers --line-range :500 {}" "$@"
}

echo "                         ⟋⟋⟋ ⟨epic-dev⟩ ⟍⟍⟍                        " 

# === Lazy Loading ===

# NVM (Node Version Manager)
# Only loads NVM when you run node, npm, etc. Speeds up shell start.
export NVM_DIR="$HOME/.config/nvm"

zsh-nvm-lazy-load() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() { zsh-nvm-lazy-load; nvm "$@" }
node() { zsh-nvm-lazy-load; node "$@" }
npm() { zsh-nvm-lazy-load; npm "$@" }
npx() { zsh-nvm-lazy-load; npx "$@" }

# Conda Initialization
__conda_setup="$('/home/epic-dev/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/epic-dev/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/epic-dev/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/epic-dev/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup