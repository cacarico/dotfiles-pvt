#!/usr/bin/env bash

DOTFILES_DIR="$HOME/ghq/github.com/cacarico/dotfiles"
GHQ_CACARICO_DIR="$HOME/ghq/github.com/cacarico"
FONTS_DIR="$HOME/.local/share/fonts"
BOOTSTRAP_DIR="scripts/bootstrap.d"
LOGS_DIR="$HOME/.local/share/logs"

# Creates default directories
create_dirs=( ~/.cache/nvim/undodir ~/Mounts/usb ~/Pictures ~/Games ~/Music ~/.local/share/waybar ~/Books ~/.themes/ "$GHQ_CACARICO_DIR" "$LOGS_DIR" )
for directory in "${create_dirs[@]}"; do
    if [ ! -d "$directory" ]; then
        mkdir -p "$directory"
    else
        echo "Directory $directory already exists, skipping..."
    fi
done

# Clones dotfiles repository
if [ ! -d "$DOTFILES_DIR" ]; then
    echo $DOTFILES_DIR
    if ! command -v git &>/dev/null; then
        echo "Installing git"
        echo sudo pacman -S git --noconfirm
    else
        echo "Git already installed, skipping..."
    fi
    mkdir -p "$GHQ_CACARICO_DIR"
    git clone git@github.com:cacarico/dotfiles.git "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
else
    echo "Dotfiles repository already cloned, skipping..."
fi

# Delete default directories before creating symbolic links
find ~/.config \( -name 'fish' -o -name 'qtile' \) -type d -exec rm -r {} +

# Create symbolic links
$BOOTSTRAP_DIR/links.sh create_links

# Start Distro Install
uname -a | grep -q arch && $BOOTSTRAP_DIR/arch.sh
uname -a | grep -q fedora && $BOOTSTRAP_DIR/fedora.sh
uname -a | grep -q kali && $BOOTSTRAP_DIR/kali.sh

#+++++ Install asdf +++++#
$BOOTSTRAP_DIR/asdf.sh

#+++++ Install Krew +++++#
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install Oh My Fish
if [ ! -d "$HOME/.local/share/omf" ]; then
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fi

# Enable service daemons
user_services=(dunst.service)
echo "Enabling service daemons"
for service in "${user_services[@]}"; do
    sudo systemctl enable --now "$service"
done

# Add user to groups
echo "Adding user $USER to groups"
for group in vboxusers video input; do
    sudo usermod -aG "$group" "$USER"
done

# Set fish as default shell
if [ "$SHELL" != "/usr/bin/fish" ]; then
    echo "Setting fish as default shell"
    chsh -s /usr/bin/fish
else
    echo "Fish already default shell, skipping..."
fi

# Sets git default configs
git config --global user.name cacarico
git config --global user.email "caio.quinilato@gmail.com"
git config --global commit.gpgsign true

echo "Installation finished."
echo "It is recomended to restart now..."
