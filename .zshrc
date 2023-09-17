if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"


[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

plugins=(git fzf-tab fast-syntax-highlighting wakatime)

source $ZSH/oh-my-zsh.sh

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

export LANG=en_US.UTF-8
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias ls="ls -a --color=auto"
alias externalssd="cd /mnt/externalssd/"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias stow.="pushd ~/.dotfiles/ > /dev/null; stow -D .; stow .; popd > /dev/null"
alias p="~/scripts/p.sh"
alias bgrng='~/scripts/bgrng.sh'

alias pyenv="set +a; set -a; source .env; source .venv/bin/activate"
alias newpyenv="python -m venv .venv && pythonenv && pip install -r requirements.txt"
