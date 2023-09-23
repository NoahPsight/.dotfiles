export ZSH="$HOME/.oh-my-zsh"
plugins=(git fzf-tab fast-syntax-highlighting zsh-wakatime)
source $ZSH/oh-my-zsh.sh

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if [[ -f ".python-version" ]] && pyenv versions --bare | grep -q "$(cat .python-version)"; then
  #echo "Virtual environment exists."
  pyenv local $(cat .python-version)
else
  # echo "No virtual environment."
fi

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
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias stow.="pushd ~/.dotfiles/ > /dev/null; stow -D .; stow .; popd > /dev/null"
alias bgrng='~/scripts/bgrng.sh'

eval "$(starship init zsh)"
   
tmux list-sessions 2>/dev/null | grep -q "attached"
if [ $? != 0 ]; then
    bash ~/scripts/jumper.sh
fi

autoload -U bashcompinit
bashcompinit
source ~/scripts/jumper.sh
