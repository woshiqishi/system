#!/bin/bash

zshrc="$HOME/.zshrc"

die() {
    local message="ERROR: $*"
    echo "$message" >&2
    exit 1
}

download_antigen() {
    remote_file="https://git.io/antigen"
    local_file="$HOME/system/dotfiles/zsh/antigen.zsh"

    remote_checksum=$(curl -sSL "$remote_file" | md5sum | awk '{print $1}')
    local_checksum=$(md5sum "$local_file" | awk '{print $1}')

    if [[ "$remote_checksum" != "$local_checksum" ]]; then
        echo "Content is different. Downloading..."
        if curl -sSL "$remote_file" -o "$local_file"; then
            echo "antigen succesfully downloaded."
        else
            die "antigen failed to download."
        fi
    else
        echo "antigen is already downloaded and up to date."
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
    local zshrc_source="$HOME/system/dotfiles/zsh/.zshrc"

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

    download_antigen
    install_zsh
    symlink_zshrc
    make_default_shell
}

# Execute main function
main "$@"
