#!/usr/bin/env fish

function project
    set selected (find ~/ghq/ -mindepth 3 -maxdepth 3 -type d | fzf)
    set clean (echo $selected | awk -F/ '{print $NF}')

    if [ $selected ]
        tmux new-window -c "$selected" -n "$clean"
        tmux send-keys -t "$clean" nvim Enter
        tmux split-window -c "$selected" -v -l 20% ';'
        tmux select-pane -U
    end
end
