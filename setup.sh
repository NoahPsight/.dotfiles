# Install pacman packages.
# Ex:
#   pinstall neovim
pinstall() {
    for package in "$@"; do
        if ! pacman -Q "$package" >/dev/null 2>&1; then
            sudo pacman -S --noconfirm "$package"
        else
            echo "$package is already installed."
        fi
    done
}

setup_system()
{
    sudo pacman -Syu
    pinstall ntfs-3g
    pinstall openssh
}

setup_dotfiles()
{
    pinstall git
    pinstall stow
    mkdir ~/.config
    git clone https://github.com/NoahPsight/.dotfiles ~/.dotfiles/
    cd ~/.dotfiles/
    stow .
}

setup_desktop()
{
    pinstall xorg-server xorg-xinit xorg-xrandr xorg-xsetroot
    pinstall sddm
    sudo systemctl enable sddm
    pinstall base-devel xorg-init libx11 libxinerama libxft webkit2gtk
    git clone https://github.com/LukeSmithxyz/dwm.git ~/.config/dwm/
    cd ~/.config/dwm
    sudo make clean install
    echo "exec dwm" > ~/.xinitrc
    sudo mkdir /usr/share/xsessions/
    echo -e "[Desktop Entry]\n\
        Encoding=UTF-8\n\
        Name=Dwm\n\
        Comment=Dynamic window manager\n\
        Exec=dwm\n\
        Icon=dwm\n\
        Type=XSession" > /usr/share/xsessions/dwm.desktop
    }

setup_nvim()
{
    pinstall neovim
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

main()
{
    setup_system
    setup_dotfiles    
    setup_desktop
    setup_nvim
    cd ~
}

main

