FONTS_DIR=~/.local/share/fonts/
FONTS_ZIP=~/fonts.zip

cd "$(dirname "$0")"

function install_base() {
    echo "===> Installing basic modules..."
    sudo pacman -S xdg-user-dirs git nano vim fuse unzip gvfs gvfs-mtp gvfs-afc gvfs-nfs gvfs-smb openssh jre11-openjdk python-pip base-devel cmake alsa-plugins alsa-utils pamixer pulseaudio
    
    echo "===> Generating local home folders..."
    xdg-user-dirs-update
}

function install_fonts() {
   echo "===> Installing fonts..."
   sudo pacman -S noto-fonts-emoji ttf-roboto-mono ttf-liberation ttf-droid
   
   curl -o $FONTS_ZIP 'https://raw.githubusercontent.com/mich4ld/zsh-setup/main/fonts.zip'
   mkdir -p $FONTS_DIR
   unzip $FONTS_ZIP -d $FONTS_DIR
   echo "===> Clearing archive..."
   rm $FONTS_ZIP
   
   sudo fc-cache -f -v
}

function install_aur() {
   echo "===> Install AUR helper..."
   git clone https://aur.archlinux.org/paru-bin.git
   cd paru-bin
   makepkg -si
   cd "$(dirname "$0")"
}

function install_tools() {
   echo "===> Install tools and utils..."
   sudo pacman -S neofetch cmatrix htop gparted redshift flameshot youtube-dl
}

function configure_dev() {
   echo "===> Installing development tools..."
   paru -S docker docker-compose jq whois zsh mongodb-compass visual-studio-code-bin insomnia-bin
   
   echo "===> Configuring Docker..."
   sudo systemctl enable --now docker.service
   sudo usermod -aG docker $USER
   
   echo "===> Configuring zsh..."
   curl https://raw.githubusercontent.com/mich4ld/zsh-setup/main/setup.sh | bash -s -- --no-fonts
   
   echo "===> Your email for git:"
   read git_email

   echo "===> Your name for git:"
   read git_name

   git config --global user.email $git_email
   git config --global user.name $git_name
}

function install_browsers() {
   echo "===> Installing browsers..."
   paru -S firefox brave-bin
}

install_base
install_aur
install_fonts
install_tools
install_browsers
configure_dev
