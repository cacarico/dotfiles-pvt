#!/usr/bin/env bash

ASDF_DIR="$HOME/.asdf"

#TODO Update ASDF repo
# Installs asdf if not already installed
if [ ! -d "$ASDF_DIR" ]; then
    echo "Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
else
    echo "Asdf already installed, updating..."
    (
        cd "$ASDF_DIR"
        git pull origin master
    )
fi

# Install asdf packages
echo "Installing asdf packages..."
while IFS= read -r package; do
    ~/.asdf/bin/asdf plugin-add "$package"
    ~/.asdf/bin/asdf install "$package" latest
    ~/.asdf/bin/asdf global "$package" latest
done < scripts/bootstrap.d/packages/asdf.install
