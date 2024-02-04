#!/usr/bin/env fish

function workstation

tmux new-session -s workstation -n main -d ';' \
    split-window -v -l 20% ';' \
    new-window -n dotfiles -d 'cd dotfiles; nvim README.md'

tmux attach-session -t workstation
end
