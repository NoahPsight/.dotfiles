paru() {
    command paru --noconfirm "$@"
    command paru -Qqen > ~/packages.txt
}
alias paruclean="sudo pacman -Rsn $(pacman -Qdtq)"

alias brb="clear && figlet BRB | lolcat"

alias  l='eza -l  --icons'
alias ls='eza -1  --icons'
alias ll='eza -la --icons'
alias ld='eza -lD --icons'

alias samwise='figlet Samwise | lolcat'
alias v="/bin/nvim"
alias vi="/bin/nvim"
alias vim="/bin/nvim"
alias emacs="/bin/nvim"

alias stow.="pushd ~/.dotfiles/; stow -D .; stow .; popd"

alias bgrng='~/Scripts/bgrng.sh'
alias clip="xclip -selection clipboard"

mkdir_and_touch() {
  mkdir -pv "$(dirname "$1")"
  touch "$1"
}
alias touch="mkdir_and_touch"


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
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
zinit light zsh-users/zsh-autosuggestions
zicompinit; zicdreplay


if [[ -f .env ]]; then
  set -a
  source ./.env
  set +a
fi

# if [[ "$PWD" != "$HOME" ]]; then
#     if [[ -f ".zshrc" ]]; then
#       source ".zshrc"
#     fi
# fi

# source /usr/share/nvm/init-nvm.sh

# bun
# [ -s "/home/fib/.bun/_bun" ] && source "/home/fib/.bun/_bun"
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"


eval "$(starship init zsh)"
