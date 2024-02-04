#!/usr/bin/env bash

DOTFILES_DIR="$HOME/ghq/github.com/cacarico/dotfiles"
FONTS_DIR="~/.local/share/fonts"

# Creates default directories
for directory in ~/Pictures ~/Games ~/Music ~/.local/bin "$DOTFILES_DIR" "$FONTS_DIR"; do
    if [ ! -d $directory ]; then
        mkdir -p $directory
    else
        echo "Directory $directory already exists, skipping..."
    fi
done

# Install fonts
echo "Installing Fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip 
unzip FiraMono.zip -d "$FONTS_DIR"

# Clones dotfiles repository
if [ ! -d "$DOTFILES_DIR/dotfiles" ]; then
    sudo pacman -S git --noconfirm
    mkdir -p $DOTFILES_DIR
    git clone https://github.com/cacarico/dotfiles.git $DOTFILES_DIR
    cd $DOTFILES_DIR
else
    echo "Dotfiles repository already cloned, skipping..."
fi

# Install packman packages
echo "Installing pacman packages..."
sudo cat packages/pacman.install | sudo pacman -S --needed --noconfirm -

# Install yay and yay packages
echo "Installing yay packages..."
scripts/bootstrap.d/yay-install.sh
yay -S --needed --noconfirm - < packages/yay.install

# Install asdf packages
echo "Installing asdf packages..."
for package in $(cat packages/asdf.install); do
    asdf plugin-add $package
    asdf install $package latest
    asdf global $package latest
done

# Install Tmux Plugin Manager
if [ ! -d "~/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install Oh My Fish
if [ ! -d "~/.local/share/omf" ]; then
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fi

# Enable service daemons
echo "Enabling service daemons"
for service in fprintd bluetooth snapd; do
    sudo systemctl enable --now $service
done

# Enable user daemons
echo "Enabling user daemons"
for user_service in podman.socket podman.service; do
    sudo systemctl enable --now $user_service
done

# Add user to groups
echo "Adding user $USER to groups"
for group in vboxusers video input; do
    sudo usermod -aG $group $USER
done

# Set fish as default shell
if [ "$SHELL" != "/usr/bin/fish" ]; then
    echo "Setting fish as default shell"
    chsh -s /usr/bin/fish
else
    echo "Fish already default shell, skipping..."
fi

# Enable fingerprint
echo "Enabling fingerpring service"
for service in sudo system-local-login; do
    sudo sed -i '/auth.*include/i auth            sufficient      pam_fprintd.so' "/etc/pam.d/$service"
done

rm -rf "~/.config/fish"
make link
make link-x
