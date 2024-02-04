#!/usr/bin/env bash

if [ ! command -v yay &> /dev/null ]; then
    pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
else
    echo "Yay already installed, skipping..."
fi
