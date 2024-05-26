#!/usr/bin/env bash

CONFIG_DIR="$PWD/config"
HOME_CONFIG_DIR="$HOME/.config"
# Creates symlinks
create_links() {

    # Links bin directory
    ln -sfF "$PWD/bin" "$HOME/bin"

    # Links config directory
    for config in "$CONFIG_DIR"/*
    do
        app=$(echo "$config" | awk -F/ '{print $NF}')
        case $app in
            rofi)
                ln -sfF "$config/config.rasi" "$HOME_CONFIG_DIR/rofi"
                continue
                ;;
            starship)
                ln -sfF "$config/starship.toml" "$HOME_CONFIG_DIR"
                continue
                ;;
            xbindkey)
                ln -sfF "$config/xbindkeysrc" "$HOME/.xbindkeysrc"
                continue
                ;;
            gnupg)
                ln -sfF "$config/gpg-agent.conf" "$HOME/.gnupg/pgp-agent.conf"
                continue
                ;;
            asdf)
                ln -sfF "$config/asdfrc" "$HOME/.asdfrc"
                continue
                ;;
        esac
        ln -sfF "$config" "$HOME_CONFIG_DIR/"
    done

    # Links Desktop Entries
    for entry in "$PWD/Desktop"/*
    do
        ln -sfF "$PWD/Desktop/$entry" "$HOME/Desktop/"
    done
}

# Create links for X
link_x() {
    sudo ln -sfF "$PWD/system/backlight/backlight.rules" /etc/udev/rules.d/
    sudo ln -sfF "$PWD/system/fingerprint/50-net.reactivated.fprint.device.enroll.rules" /etc/polkit-1/rules.d/
    sudo ln -sfF "$PWD/system/modprobe/nobeep.conf" /etc/modprobe.d/
    sudo ln -sfF "$PWD/system/NetworkManager/09-timezone" /etc/NetworkManager/dispatcher.d/
    sudo ln -sfF /var/lib/snapd/snap /snap
    sudo ln -sfF /run/podman/podman.sock /var/run/docker.sock
}

# Remove symlinks
remove_links() {
    for config in "$CONFIG_DIR"/*
    do
        file="${config#"$CONFIG_DIR"/}"
        unlink "$HOME_CONFIG_DIR/$file" 2>/dev/null
    done
}

case $1 in
    create_links)
        create_links
        ;;
    link_x)
        link_x
        ;;
    remove_links)
        remove_links
        ;;
    *)
        echo "Option $1 not found"
        ;;
esac
