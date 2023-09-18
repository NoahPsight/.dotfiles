export ZSH="$HOME/.oh-my-zsh"
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
alias p="sh ~/scripts/p.sh"
alias bgrng='~/scripts/bgrng.sh'

alias pyenv="set +a; set -a; source .env; source .venv/bin/activate"
alias newpyenv="touch .env && python -m venv .venv && pyenv && pip install -r requirements.txt"

eval "$(starship init zsh)"
