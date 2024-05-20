#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to update and Install DNF Packages
# -----------------------------------------------------------------------------

LOGS_DIR="$HOME/.local/share/logs"
BOOTSTRAP_DIR="scripts/bootstrap.d"
PACKAGES_DIR="$BOOTSTRAP_DIR/packages"
GHQ_DIR="$HOME/ghq"

install_starship() {
    # Install Starship
    if ! command -v starship &> /dev/null
    then
        echo Installing starship
        sudo dnf -y copr enable atim/starship
        sudo dnf -y install starship
    fi
}

install_brave() {
    if ! command -v brave-browser &> /dev/null
    then
        sudo dnf install dnf-plugins-core
        sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo dnf install brave-browser
    fi

}

install_swww() {


    # Clones the repository and install swww
    ghq get https://github.com/LGFae/swww.git
    (
        cd "$GHQ_DIR/LGFae/swww"

        # Build Package and creates link to ~/bin
        cargo build --release
        sudo ln -sfF "$PWD/target/release/swww" /usr/bin/swww
        sudo ln -sfF "$PWD/target/release/swww-daemon" /usr/bin/swww-daemon

        # Builds
        ./doc/gen.sh
    )
}

install_brillo() {

    ghq get git@github.com:CameronNemo/brillo.git
    (
    cd "$GHQ_DIR/brillo"

    # Build Package and Install
    make buil
    make install
)

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
    sudo dnf -y install $(cat $PACKAGES_DIR/dnf.install)
}

update_install
install_starship
