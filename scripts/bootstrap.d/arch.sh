#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to configure Archlinux
# -----------------------------------------------------------------------------


DOTFILES_DIR="$HOME/ghq/github.com/cacarico/dotfiles"
BOOTSTRAP_DIR="scripts/bootstrap.d"

# Clones dotfiles repository
if [ ! -d "$DOTFILES_DIR/dotfiles" ]; then
    sudo pacman -S git --noconfirm
    mkdir -p "$DOTFILES_DIR"
    git clone https://github.com/cacarico/dotfiles.git "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
else
    echo "Dotfiles repository already cloned, skipping..."
fi

# Install packman packages
$BOOTSTRAP_DIR/pacman.sh

# Install yay and yay packages
$BOOTSTRAP_DIR/yay.sh

# Install asdf
$BOOTSTRAP_DIR/asdf.sh

# Enable service daemons
echo "Enabling service daemons"
for service in fprintd bluetooth snapd snapd.apparmor cups.socket avahi-daemon.service; do
    sudo systemctl enable --now $service
done

# Enable user daemons
echo "Enabling user daemons"
for user_service in podman.socket podman.service; do
    sudo systemctl --user enable --now $user_service
done

# Add user to groups
echo "Adding user $USER to groups"
for group in vboxusers video input; do
    sudo usermod -aG "$group" "$USER"
done

# Enable fingerprint
$BOOTSTRAP_DIR/fingerprint.sh