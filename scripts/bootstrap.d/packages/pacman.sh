#!/usr/bin/env bash

echo "Starting Arch Linux installation"
sudo pacman -Syu --noconfirm
sudo pacman -S --needed virtualbox virtualbox-guest-iso
sudo cat $BOOTSTRAP_DIR/pacman.install | sudo pacman -S --needed --noconfirm -
