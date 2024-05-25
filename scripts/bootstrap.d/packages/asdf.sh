#!/usr/bin/env bash

DOTFILES_DIR="$HOME/ghq/github.com/cacarico/dotfiles"
PACKAGES_DIR="$BOOTSTRAP_DIR/packages"
PACKAGES_YAML="scripts/bootstrap.d/packages/asdf.yaml"

ASDF_DIR="$HOME/.asdf"

# Installs asdf if not already installed
if [ ! -d "$ASDF_DIR" ]; then
    echo "Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf > /dev/null 2>&1
        if [ "$?" -eq 0 ]; then
            echo "Package asdf installed ✅"
        fi
else
    echo -ne "Asdf already installed, updating..."
    (
        cd "$ASDF_DIR"
        git pull origin master > /dev/null 2>&1
        if [ "$?" -eq 0 ]; then
            echo -e " Done ✅"
        fi
    )
fi

packages=$(yq '.packages[].name' $PACKAGES_YAML | tr -d \")
echo "Installing asdf packages..."
for package in $packages; do
    versions=$(yq ".packages[] | select(.name == \"$package\") | .versions" $PACKAGES_YAML | sed 's/\[//g; s/\]//g; s/,//g; s/\"//g')
    for version in $versions; do
        ~/.asdf/bin/asdf plugin add "$package"  > /dev/null 2>&1
        ~/.asdf/bin/asdf install "$package" "$version" > /dev/null 2>&1
        ~/.asdf/bin/asdf global "$package" "$version" > /dev/null 2>&1
        if [ "$?" -eq 0 ]; then
            echo "Package $package version $version installed ✅"
        else
            echo "Package $package version $version ERROR ❌"
        echo "~/.asdf/bin/asdf global \"$package\" \"$version\" > /dev/null 2>&1"
        fi
    done
done
