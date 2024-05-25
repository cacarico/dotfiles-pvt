#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to configure Fedora
# -----------------------------------------------------------------------------

BOOTSTRAP_DIR="scripts/bootstrap.d"
PACKAGES_DIR="$BOOTSTRAP_DIR/packages"

#======= Fedora Setup ======#

#+++++ Add Repositories +++++#
wget -O- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo | sudo tee /etc/yum.repos.d/hashicorp.repo # Hashcorp

#+++++ Install dnf packages +++++#
$PACKAGES_DIR/dnf.sh

#+++++ Install Obsidian +++++#
flatpak install flathub md.obsidian.Obsidian

#+++++ Enable service daemons +++++#
echo "Enabling service daemons"

#TODO  for service in snapd snapd.apparmor; do
daemon_services=('snapd')
for service in "${daemon_services[@]}"; do
    sudo systemctl enable --now "$service"
done

#TODO Enable user daemons
echo "Enabling user daemons"
user_services=()
for user_service in "${user_services[@]}" ; do
    sudo systemctl --user enable --now "$user_service"
done

#+++++ Add user to groups +++++#
echo "Adding user $USER to groups"
for group in vboxusers video input; do
    sudo usermod -aG "$group" "$USER"
done

#+++++ Enable fingerprint +++++#
$BOOTSTRAP_DIR/fingerprint.sh
