#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to update and Install DNF Packages
# -----------------------------------------------------------------------------

GHQ_DIR="$HOME/ghq"

install_starship() {
    # Install Starship
    if ! command -v starship &> /dev/null; then
        echo Installing starship
        sudo dnf -y copr enable atim/starship
        sudo dnf -y install starship
    fi
}

install_brave() {
    if ! command -v brave-browser &> /dev/null; then
        sudo dnf install dnf-plugins-core
        sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo dnf install brave-browser
    fi
}

install_swww() {

    if ! command -v swww &> /dev/null; then
        # Clones the repository and install swww
        ghq get https://github.com/LGFae/swww.git
        (
            cd "$GHQ_DIR/LGFae/swww" || return 1

            # Build Package and creates link to ~/bin
            cargo build --release
            sudo ln -sfF "$PWD/target/release/swww" /usr/bin/swww
            sudo ln -sfF "$PWD/target/release/swww-daemon" /usr/bin/swww-daemon

            # Builds
            ./doc/gen.sh
        )
    fi
}

install_brillo() {

    if ! command -v brillo &> /dev/null; then
        ghq get git@github.com:CameronNemo/brillo.git
        (
        cd "$GHQ_DIR/brillo" || return 1

        # Build Package and Install
        make build
        sudo make install
        )
    fi
}

install_lazygit() {
    if ! command -v lazygit &> /dev/null; then
        sudo dnf -y copr enable atim/lazygit -y
        sudo dnf -y install lazygit
    fi
}

install_swaylock() {
    if ! command -v swaylock &> /dev/null; then
        ghq get git@github.com:mortie/swaylock-effects.git
        (
            cd "$GHQ_DIR/mortie/swaylock-effects" || return 1

            # Build and Install
            meson build
            ninja -C build
            sudo ninja -C build install
        )
    fi
}

install_forticlient() {
    if ! command -v forticlient &> /dev/null; then
        sudo dnf config-manager --add-repo https://repo.fortinet.com/repo/7.0/centos/8/os/x86_64/fortinet.repo
        sudo dnf install forticlient
    fi
}

install_github_cli() {
    if ! command -v gh &> /dev/null; then
        sudo dnf -y install 'dnf-command(config-manager)'
        sudo dnf -y config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
        sudo dnf -y install gh
    fi
}

install_1password() {
    if ! command -v 1password &> /dev/null; then
        sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
        sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
        sudo dnf -y install 1password
    fi
}

install_dracula_gtk() {
    # Install Theme
    if [ ! -d "$HOME/.theme/dracula" ]; then
        wget https://github.com/dracula/gtk/archive/master.zip
        unzip master.zip
        mv gtk-master/ ~/.themes/dracula
        rm -f master.zip

        # Install Icons
        wget https://github.com/dracula/gtk/files/5214870/Dracula.zip
        unzip Dracula.zip
        mv Dracula ~/.icons
        rm -f Dracula.zip
    fi
}

cleanup() {
    # Clean up DNF cache
    echo "Cleaning all DNF cache..."
    sudo dnf -y clean all

    # Remove orphaned packages
    echo "Removing orphaned packages..."
    sudo dnf -y autoremove
}

update_install() {
    # Update and install DNF Packages
    echo "Updating and Installing Fedora Packages"
    # sudo dnf -y update
    sudo dnf -y install "$(cat $PACKAGES_DIR/dnf.install)"
}

update_install
install_starship
install_swww
