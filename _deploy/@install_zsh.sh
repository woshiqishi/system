#!/bin/bash

# Function to check Zsh installation and execute in test mode
check_zsh_installation() {
    if ! command -v zsh &>/dev/null; then
        echo "Zsh is not installed. Installing Zsh..."
        sudo apt install zsh

        # Set Zsh as the default shell
        if [ "$SHELL" != "$(which zsh)" ]; then
            echo "Setting Zsh as the default shell..."
            if chsh -s "$(which zsh)"; then
                echo "Done! restart your terminal."
            fi
        fi
    else
        echo "Zsh is already installed."
    fi
}

make_default_shell() {
    # Set Zsh as the default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Setting Zsh as the default shell..."
        chsh -s "$(which zsh)"
        echo "Done! Do you want to log out? (y/n)"
        read -r choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            gnome-session-quit
        fi
    fi
}

symlink_zshrc() {
    local zshrc_directory="$HOME/system/dotfiles/zsh/.zshrc"

    if ln -sf $zshrc_directory $HOME; then
        echo ".zshrc symlink successfully created"
    else
        echo "ERROR: .zshrc symlink not created"
    fi
}

install_antigen() {
    # Install antigen
    if curl -L git.io/antigen > "$HOME/system/dotfiles/zsh/antigen.zsh"; then
        echo "Antigen was successfully installed."
    else
        echo "ERROR: antigen was not installed correctly!"
    fi
}

install_plugins() {
    # local spaceship-prompt=
    # local zsh-autosuggestions=
    # local zsh-syntax-highlighting=
    echo "nothing"
}

# Main function
main() {
    # Call additional functions and logic here as needed
    check_zsh_installation "$@"
    make_default_shell "$@"
    symlink_zshrc "$@"
    install_antigen "$@"
    #install_ohmyzsh_plugins "$@"
}

# Execute main function
main "$@"
