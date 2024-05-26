#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to configure Archlinux
# -----------------------------------------------------------------------------

MKINITCPIO='/etc/mkinitcpio.conf'

echo "Starting Arch Install"

# Install pacman packages
$PACKAGES_DIR/pacman.sh

# Install yay and yay packages
$PACKAGES_DIR/yay.sh

# Enables numlock on boot
if ! grep -q numlock "$MKINITCPIO"; then
    sudo sed -i '/^HOOKS=/ s/)/ numlock&/' "$MKINITCPIO"
fi
