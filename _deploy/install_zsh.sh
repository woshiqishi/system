#!/bin/bash

zshrc="$HOME/.zshrc"
zsh_dot="$HOME/system/dotfiles/zsh"

die() {
    local message="ERROR: $*"
    echo "$message" >&2
    exit 1
}

download_zplug() {
    local zplug_repo="https://github.com/zplug/zplug"

    export ZPLUG_HOME="$zsh_dot/zplug"

    if ! [ -d "$ZPLUG_HOME" ]; then
        # if the directory doesn't exist, then clone zplug into zplug_home
        if mkdir "$ZPLUG_HOME" && git clone "$zplug_repo" "$ZPLUG_HOME"; then
            echo "zplug successfully cloned"
        else
            die "zplug cloning went wrong"
        fi
    else
        echo "zplug is already downloaded"
    fi
}

install_zsh() {
    if ! command -v zsh &>/dev/null; then
        echo "Zsh is not installed. Installing Zsh..."
        if sudo apt install -y zsh; then
            echo "zsh installed correctly"
        else
            die "zsh failed in install"
        fi
    else
        echo "Zsh is already installed."
    fi
}

symlink_zshrc() {
    local zshrc_source="$zsh_dot/.zshrc"

    if [[ -L "$zshrc" && "$(readlink "$zshrc")" == "$zshrc_source" ]]; then
        echo ".zshrc is already linked."
    else
        if ln -sf "$zshrc_source" "$zshrc"; then
            echo ".zshrc symlink successfully created"
        else
            die ".zshrc symlink not created"
        fi
    fi
}

make_default_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Setting zsh as the default shell..."
        if chsh -s "$(which zsh)"; then
            echo "Done! Do you want to log out? (y/n)"
            read -r choice
            if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
                gnome-session-quit
            fi
        else
            die "couldn't set zsh as the default shell."
        fi
    else
        echo "zsh is your default shell."
    fi
}

# Main function
main() {
    # enable xtrace mode
    if [[ "$1" == "--test" ]]; then
        set -x
    fi
    
    download_zplug
    install_zsh
    symlink_zshrc
    make_default_shell
}

# Execute main function
main "$@"
