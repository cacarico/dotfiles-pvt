#!/usr/bin/env bash


git clone https://github.com/cacarico/dotfiles.git ~/ghq/github.com/cacarico/dotfiles

sudo cat packages/pacman.install | sudo pacman -S --needed -
yay -S --needed - < packages/yay.install

for package in $(cat packages/asdf.install); do
    asdf plugin-add $package
    asdf install $package latest
    asdf global $package latest
done

make link
make link-x
