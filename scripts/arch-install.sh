#!/usr/bin/env bash


DOTFILES_DIR="~/ghq/github.com/cacarico/dotfiles"

git clone https://github.com/cacarico/dotfiles.git $DOTFILES_DIR
cd $DOTFILES_DIR

sudo cat packages/pacman.install | sudo pacman -S --needed -
yay -S --needed - < packages/yay.install

for package in $(cat packages/asdf.install); do
    asdf plugin-add $package
    asdf install $package latest
    asdf global $package latest
done

make link
make link-x
