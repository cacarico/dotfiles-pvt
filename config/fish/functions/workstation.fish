#!/usr/bin/env fish

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to spawn tmux with dotfiles and the main
# -----------------------------------------------------------------------------


function workstation
    if not tmux list-sessions | grep -q workstation
        tmux new-session -s workstation -n main -d \; \
            split-window -v -l 20% \; \
            new-window -t workstation -n dotfiles -d 'cd ~/ghq/github.com/cacarico/dotfiles-pvt; nvim' \; \
            select-window -t workstation:dotfiles \; \
            split-window -v -l 20% \; \
            send-keys -t workstation:dotfiles.2 'cd ~/ghq/github.com/cacarico/dotfiles-pvt; clear' C-m \; \
            select-window -t workstation:dotfiles
    end

    tmux attach-session -t workstation
end