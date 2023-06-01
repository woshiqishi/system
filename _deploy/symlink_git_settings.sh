#!/bin/bash

if command -v git >/dev/null 2>&1; then
    # 'git' is installed
    if ln -sf "$HOME/system/dotfiles/git/.gitconfig" "$HOME/.gitconfig"; then
        echo "git symlink created successfully."
    else
        echo "git symlink was not created."
    fi
else
    # 'git' is not installed
    echo "git is not installed on this system."
fi

