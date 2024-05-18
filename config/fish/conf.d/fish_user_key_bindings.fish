#!/usr/bin/env fish

function fish_user_key_bindings
    # peco
    bind \cr peco_history
# bind \cf peco_change_directory
    bind \cP project
    bind \cg floating_git
end
