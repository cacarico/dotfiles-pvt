#!/usr/bin/env bash

DOTFILES_DIR="$HOME/ghq/github.com/cacarico/dotfiles"

# Creates default directories
for directory in ~/Pictures ~/Games ~/Music ~/.local/bin "$DOTFILES_DIR" ~/.local/share/fonts/; do
    mkdir -p $directory
done

# Clones dotfiles repository
if [ ! -d $DOTFILES_DIR/dotfiles ]; then
    sudo pacman -S git
    mkdir -p $DOTFILES_DIR
    git clone https://github.com/cacarico/dotfiles.git $DOTFILES_DIR
    cd $DOTFILES_DIR
fi

# Install packman packages
sudo cat packages/pacman.install | sudo pacman -S --needed -

# Install yay and yay packages
scripts/install/yay-install.sh
yay -S --needed - < packages/yay.install

# Install asdf packages
for package in $(cat packages/asdf.install); do
    asdf plugin-add $package
    asdf install $package latest
    asdf global $package latest
done

# Install Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Oh My Fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

# Enable service daemons
for service in fprintd bluetooth snapd; do
    sudo systemctl enable --now $service
done

# Enable user service daemons
for user_service in podman.socket podman.service; do
    sudo systemctl enable --now $user_service
done
# Add user to groups
for group in vboxusers video input; do
    sudo usermod -aG $group cacarico
done

# Set fish as default shell
chsh -s /usr/bin/fish

# Enable fingerprint
for service in sudo system-local-login; do
    sed '/auth.*include/i auth            sufficient      pam_fprintd.so' "/etc/pam.d/$service"
done

make link
make link-x
