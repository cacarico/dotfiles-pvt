#!/usr/bin/env bash

BOOTSTRAP_DIR="scripts/bootstrap.d"

echo "Starting Arch Linux installation"

# Install packman packages
sudo pacman -S virtualbox virtualbox-guest-iso
sudo cat packages/pacman.install | sudo pacman -S --needed --noconfirm -

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
echo "Enabling fingerprint for services:"
for service in sudo system-local-login; do
    if ! grep -q fprintd "/etc/pam.d/$service"; then
        sudo sed -i '/auth.*include/i auth            sufficient      pam_fprintd.so' "/etc/pam.d/$service"
    else
        echo "Fingerprint already configured for $service, skipping..."
    fi
done
