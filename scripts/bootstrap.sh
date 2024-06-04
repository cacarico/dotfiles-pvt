#!/usr/bin/env bash

export GHQ_CACARICO_DIR="$HOME/ghq/github.com/cacarico"
export BOOTSTRAP_DIR="scripts/bootstrap.d"
export DOTFILES_DIR="$GHQ_CACARICO_DIR/dotfiles-pvt"
export LOGS_DIR="$HOME/.local/share/logs"
export PACKAGES_DIR="$BOOTSTRAP_DIR/packages"

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
    (
        mkdir -p "$GHQ_CACARICO_DIR"
        git clone git@github.com:cacarico/dotfiles.git "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
    )
else
    echo "Dotfiles repository already cloned, skipping..."
fi

# Delete default directories before creating symbolic links
echo "Deleting default directories"
# find ~/.config \( -name 'fish' -o -name 'qtile' \) -type d -exec rm -r {} +

# Create symbolic links
echo "Creating Links"
# $BOOTSTRAP_DIR/links.sh create_links

# Start Distro Install
uname -a | grep -q arch && $BOOTSTRAP_DIR/arch.sh
uname -a | grep -q fedora && $BOOTSTRAP_DIR/fedora.sh
uname -a | grep -q kali && $BOOTSTRAP_DIR/kali.sh

#+++++ Install asdf +++++#
$BOOTSTRAP_DIR/asdf.sh

#+++++ Install Krew +++++#
echo "Installing Krew"
if ! command -v kubectl-krew &> /dev/null; then
    (
        set -x; cd "$(mktemp -d)" &&
        OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
        KREW="krew-${OS}_${ARCH}" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
        tar zxvf "${KREW}.tar.gz" &&
        ./"${KREW}" install krew
    )
fi

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
    systemctl --user enable --now "$service"
done


# Enable fingerprint
$BOOTSTRAP_DIR/fingerprint.sh

# Enable service daemons
services=(bluetooth.service)
echo "Enabling service daemons"
for service in "${services[@]}"; do
    sudo systemctl enable --now "$service"
done

# Set fish as default shell
if [ "$SHELL" != "/usr/bin/fish" ]; then
    echo "Setting fish as default shell"
    chsh -s /usr/bin/fish
else
    echo "Fish already default shell, skipping..."
fi

# Sets git default configs
echo "Setting up git global configs"
git config --global user.name cacarico
git config --global user.email "caio.quinilato@gmail.com"
git config --global commit.gpgsign true

echo "Installation finished."
echo "It is recomended to restart now..."
