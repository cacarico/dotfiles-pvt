#!/usr/bin/env bash

DOTFILES_DIR="$HOME/ghq/github.com/cacarico/dotfiles"
GHQ_CACARICO_DIR="$HOME/ghq/github.com/cacarico"
FONTS_DIR="$HOME/.local/share/fonts"
BOOTSTRAP_DIR="scripts/bootstrap.d"

# Creates default directories
for directory in ~/Mounts/usb ~/Pictures ~/Games ~/Music ~/.local/bin ~/.local/share/waybar ~/Books $GHQ_CACARICO_DIR; do
    if [ ! -d "$directory" ]; then
        mkdir -p "$directory"
    else
        echo "Directory $directory already exists, skipping..."
    fi
done

# Clones dotfiles repository
if [ ! -d "$DOTFILES_DIR/dotfiles" ]; then
    if command -v git &>/dev/null; then
        echo "Installing git"
        sudo pacman -S git --noconfirm
    else
        echo "Git already installed, skipping..."
    fi
    mkdir -p "$GHQ_CACARICO_DIR"
    git clone https://github.com/cacarico/dotfiles.git "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
else
    echo "Dotfiles repository already cloned, skipping..."
fi

[ "$(uname -a | grep arch)" ] && $BOOTSTRAP_DIR/arch.sh
[ "$(uname -a | grep fedora)" ] && $BOOTSTRAP_DIR/fedora.sh
[ "$(uname -a | grep kali)" ] && $BOOTSTRAP_DIR/kali.sh

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install Oh My Fish
if [ ! -d "$HOME/.local/share/omf" ]; then
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fi

# Sets git default configs
git config --global user.name cacarico
git config --global user.email "caio.quinilato@gmail.com"

# Set fish as default shell
if [ "$SHELL" != "/usr/bin/fish" ]; then
    echo "Setting fish as default shell"
    chsh -s /usr/bin/fish
else
    echo "Fish already default shell, skipping..."
fi

# Delete default directories before creating symbolic links
find ~/.config \( -name 'fish' -o -name 'qtile' \) -type d -exec rm -r {} +

# Create symbolic links
$BOOTSTRAP_DIR/links.sh create_links
$BOOTSTRAP_DIR/links.sh link_x

echo "Installation finished."
echo "It is recomended to restart now..."
