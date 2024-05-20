#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to configure Fedora
# -----------------------------------------------------------------------------


DOTFILES_DIR="$HOME/ghq/github.com/cacarico/dotfiles"
BOOTSTRAP_DIR="scripts/bootstrap.d"
PACKAGES_DIR="$BOOTSTRAP_DIR/packages"

# Install dnf packages
$PACKAGES_DIR/dnf.sh

# Install asdf
$BOOTSTRAP_DIR/asdf.sh

# Enable service daemons
echo "Enabling service daemons"
#TODO  for service in snapd snapd.apparmor; do
for service in snapd; do
    sudo systemctl enable --now $service
done

#TODO Enable user daemons
echo "Enabling user daemons"
for user_service in ; do
    sudo systemctl --user enable --now $user_service
done

# Add user to groups
echo "Adding user $USER to groups"
for group in vboxusers video input; do
    sudo usermod -aG "$group" "$USER"
done

# Enable fingerprint
$BOOTSTRAP_DIR/fingerprint.sh
