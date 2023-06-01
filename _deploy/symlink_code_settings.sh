#!/bin/bash

if command -v code >/dev/null 2>&1; then
    # 'code' is installed
    if ln -sf "$HOME/system/dotfiles/code/settings.json" "$HOME/.config/Code - OSS/User/settings.json"; then
        echo "Code symlink created successfully."
    else
        echo "Code symlink was not created."
    fi
else
    # 'code' is not installed
    echo "Visual Studio Code is not installed on this system."
fi

