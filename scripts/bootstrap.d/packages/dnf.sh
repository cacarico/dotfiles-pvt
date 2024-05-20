#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to update and Install DNF Packages
# -----------------------------------------------------------------------------

LOGS_DIR="$HOME/.local/share/logs"

# Update and install DNF Packages
echo "Updating and Installing Fedora Packages"
sudo dnf -y update
sudo dnf -y install $(cat dnf.install)

# Clean up DNF cache
echo "Cleaning all DNF cache..."
sudo dnf clean all

# Remove orphaned packages
echo "Removing orphaned packages..."
sudo dnf autoremove
