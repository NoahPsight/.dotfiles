pinstall() {
    # Install pacman packages.
    # Ex:
    #   pinstall neovim
    for package in "$@"; do
        if ! pacman -Q "$package" >/dev/null 2>&1; then
            sudo pacman -S --noconfirm "$package"
        else
            echo "$package is already installed."
        fi
    done
}

setup_dotfiles() {
    pinstall git
    pinstall stow
    mkdir -p ~/.config
    git clone --recursive https://github.com/NoahPsight/.dotfiles ~/.dotfiles/
    pushd ~/.dotfiles/
    stow .
    popd
}

setup_system() {
    pinstall ntfs-3g
    pinstall openssh
    pinstall openssh
    pinstall xclip
    pinstall neofetch
    pinstall scrot
    pinstall feh
    pinstall figlet
    pinstall nodejs
    pinstall npm
    pinstall kitty
}

setup_desktop() {
    pinstall xorg-server xorg-xinit xorg-xrandr xorg-xsetroot
    pinstall sddm
    pinstall base-devel xorg-init libx11 libxinerama libxft webkit2gtk
    sudo systemctl enable sddm
    for dir in dwm st dmenu; do
        pushd ~/.config/"$dir"
        sudo make clean install
        popd
    done
    if [ ! -f ~/.xinitrc ]; then
        echo "exec dwm" > ~/.xinitrc
    fi
    sudo mkdir -p /usr/share/xsessions/
    cat << EOF | sudo tee /usr/share/xsessions/dwm.desktop > /dev/null
[Desktop Entry]
Encoding=UTF-8
Name=Dwm
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
EOF
}

setup_shell() {
    pinstall zsh
    pinstall zsh-autosuggestions
    pinstall zsh-syntax-highlighting
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting/
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
    git clone --depth 1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
}

setup_nvim() {
    pinstall neovim
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

setup_audio() {
    pinstall pipewire-jack pipwire-alsa pipewire-pulse qjackctl
    pinstall wireplumber
    pinstall helvum
}

main() {
    sudo pacman -Syu --noconfirm
    rm delete_me
    setup_system
    setup_dotfiles    
    setup_desktop
    setup_shell
    setup_nvim
    setup_audio
}

main

