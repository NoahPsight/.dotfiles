tmux list-sessions 2>/dev/null | grep -q "attached"
if [ $? != 0 ]; then
    bash ~/Scripts/jumper.sh
fi
    
alias paru="paru --noconfirm"
alias pacman="pacman --noconfirm"
alias yay="yay --noconfirm"
alias ls="exa -a"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias stow.="pushd ~/.dotfiles/; stow -D .; stow .; popd"
alias bgrng='~/Scripts/bgrng.sh'
alias clip="xclip -selection clipboard"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export LANG=en_US.UTF-8
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zdharma-continuum/zinit-annex-as-monitor
zinit light zdharma-continuum/zinit-annex-bin-gem-node
zinit light zdharma-continuum/zinit-annex-patch-dl
zinit light zdharma-continuum/zinit-annex-rust
zinit light Aloxaf/fzf-tab
zicompinit; zicdreplay

eval "$(starship init zsh)"

