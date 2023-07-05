pinstall() {
    for package in "$@"; do
        echo "Installing $package"
        if ! pacman -Q "$package" >/dev/null 2>&1; then
            sudo pacman -S --noconfirm --needed "$package"
        else
            echo "$package is already installed."
        fi
    done
}
yinstall() {
    for package in "$@"; do
        echo "Installing $package"
        if ! yay -Q "$package" >/dev/null 2>&1; then
            yay -S --noconfirm --needed "$package"
        else
            echo "$package is already installed."
        fi
    done
}
sinstall() {
    for package in "$@"; do
        echo "Installing $package"
        if ! snap list "$package" >/dev/null 2>&1; then
            sudo snap install "$package"
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
    pinstall scrot xclip maim
    yinstall gromit-mpx
    sudo ln -s /home/fib/scripts/screenshot.sh /usr/local/bin/screenshot
    pinstall neofetch
    pinstall htop
    pinstall feh
    pinstall nodejs npm
    pinstall unzip
    pinstall gnome-themes-extra
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    mkdir -p ~/Downloads/
    pushd ~/Downloads/
    # if [ ! -d /usr/share/themes/Graphite-Dark-nord ]; then
    #     curl -O 'https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1631876298/Graphite-Dark-nord.tar.xz?response-content-disposition=attachment%3B%2520Graphite-Dark-nord.tar.xz&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20230610%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230610T221232Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=f3de43e04978f501d9271f3aa70dce371cfde332d9a1da053ea57e3f2a297db2' 
    #     tar -xf Graphite-Dark-nord.tar.xz
    #     rm Graphite-Dark-nord.tar.xz
    #     sudo mv Graphite-Dark-nord/ /usr/share/themes/
    # fi
    popd
    pinstall grub-customizer os-prober
    pinstall polkit-gnome
    if ! command -v yay >/dev/null; then
        git clone https://aur.archlinux.org/yay.git ~/yay/
        pushd ~/yay/
        makepkg -si
        popd
        rm -rf ~/yay/
    fi
    if ! command -v snap >/dev/null; then
        git clone https://aur.archlinux.org/snapd.git ~/snapd/
        pushd ~/snapd/
        makepkg -si
        popd
        sudo systemctl enable --now snapd.socket
        rm -rf ~/snapd/
    fi
    pinstall lsof
    pinstall gnome-font-viewer
    pinstall docker docker-compose
}


setup_winapps(){
    pinstall qemu virt-manager virt-viewer xfreerdp dnsmasq vde2 bridge-utils openbsd-netcat libguestfs ebtables iptables-nft
    echo '''
    unix_sock_rw_perms = "0770"
    unix_sock_group = "libvirt"
    ''' | sudo tee -a /etc/libvirt/libvirtd.conf &>/dev/null
    mkdir -p ~/.config/libvirt/
    echo 'uri_default = "qemu:///system"' >> ~/.config/libvirt/libvirt.conf
    sudo usermod -aG libvirt $(whoami)
    pushd ~/Downloads/
    curl -LO https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
    git clone https://github.com/Fmstrat/winapps.git ~/winapps/
    popd
    mkdir -p ~/.config/winapps/
    echo -e 'RDP_USER="fib"\nRDP_PASS="1234"\nMULTIMON="true"' > ~/.config/winapps/winapps.conf
    ~/winapps/installer.sh
}

setup_fun() {
    pinstall figlet
    pinstall cmatrix
}

setup_desktop() {
    pinstall xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xhost
    pinstall sddm
    pinstall base-devel xorg-init libx11 libxinerama libxft webkit2gtk
    pinstall picom
    sudo systemctl enable sddm
    for dir in dwm dmenu; do
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
Name=dwm
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
EOF
}

setup_shell() {
    pinstall zsh zsh-autosuggestions zsh-syntax-highlighting
    pinstall kitty tmux fzf
    local ohmyzsh_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ohmyzsh_dir/plugins/fast-syntax-highlighting/
    git clone --depth 1 https://github.com/romkatv/powerlevel10k.git $ohmyzsh_dir/themes/powerlevel10k
    git clone https://github.com/Aloxaf/fzf-tab $ohmyzsh_dir/plugins/fzf-tab
    git clone https://github.com/sobolevn/wakatime-zsh-plugin.git $ohmyzsh_dir/plugins/wakatime
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

setup_nvim() {
    pinstall neovim ripgrep
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

setup_audio() {
    pinstall pipewire pipewire-alsa pipewire-pulse wireplumber
    sudo pacman -Rns pulseaudio
    systemctl --user --now disable pulseaudio
    systemctl --user --now enable pipewire pipewire-pulse wireplumber
    pinstall pavucontrol
    pinstall qpwgraph
    pinstall easyeffects
}

setup_apps() {
    pinstall discord
    pinstall firefox
    pinstall keepassxc
    yinstall tableplus
    yinstall postman-bin
    pinstall vimb
    pinstall obs-studio
    pinstall vlc
    pinstall telegram-desktop
    sinstall bluemail
}
main() {
    sudo pacman -Syu --noconfirm
    rm delete_me
    setup_system
    setup_winapps
    setup_dotfiles    
    setup_desktop
    setup_shell
    setup_nvim
    setup_audio
    setup_apps
    setup_fun
}

if [ $# -eq 0 ]; then
    main
    exit 0
else
    for arg in "$@"; do
        $arg
    done
fi

