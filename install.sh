FONTS_DIR=~/.local/share/fonts/
cd "$(dirname "$0")"

function install_base() {
    echo "Installing basic modules..."
    sudo pacman -S xdg-user-dirs git nano vim fuse unzip gvfs gvfs-mtp gvfs-afc gvfs-nfs gvfs-smb openssh jre11-openjdk python-pip base-devel cmake alsa-plugins alsa-utils pamixer pulseaudio
    
    echo "Generating local home folders..."
    xdg-user-dirs-update
}

function install_fonts() {
   echo "Installing fonts..."
   sudo pacman -S noto-fonts-emoji ttf-roboto-mono ttf-liberation ttf-droid
   mkdir -p $FONTS_DIR
   cp -v ./fonts/* $FONTS_DIR
   sudo fc-cache -f -v
}

function install_aur() {
   echo "Install AUR helper..."
   git clone https://aur.archlinux.org/paru-bin.git
   cd paru-bin
   makepkg -si
   cd "$(dirname "$0")"
}

function install_tools() {
   echo "Install tools and utils..."
   sudo pacman -S neofetch cmatrix htop gparted redshift flameshot youtube-dl
}

function configure_dev() {
   echo "Installing development tools..."
   sudo pacman -S docker docker-compose jq whois zsh
   
   echo "Configuring Docker..."
   sudo systemctl start docker.service
   sudo systemctl enable docker.service
   sudo usermod -aG docker $USER

   echo "Installing oh my zsh..."
   sh -c "$(curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"   
   echo "Installing some zsh plugins..."
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
   
   echo "Your email for git:"
   read git_email

   echo "Your name for git:"
   read git_name

   git config --global user.email $git_email
   git config --global user.name $git_name

   echo "Installing development tools from AUR..."
   paru -S mongodb-compass visual-studio-code-bin insomnia-bin
}

function install_browsers() {
   echo "Installing browsers..."
   paru -S firefox brave-bin
}

install_base
install_aur
install_fonts
install_tools
install_browsers
