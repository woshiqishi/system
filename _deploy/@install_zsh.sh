#!/bin/bash

# Function to check Zsh installation and execute in test mode
check_zsh_installation() {
    if ! command -v zsh &>/dev/null; then
        if [ "$1" = "--test" ]; then
            echo "Test mode: Zsh is not installed."
            echo "Command to be executed: sudo apt install zsh"
        else
            echo "Zsh is not installed. Installing Zsh..."
            sudo apt install zsh

            # Set Zsh as the default shell
            if [ "$SHELL" != "$(which zsh)" ]; then
                echo "Setting Zsh as the default shell..."
                chsh -s "$(which zsh)"
            fi
        fi
    else
        if [ "$1" = "--test" ]; then
            echo "Test mode: Zsh is already installed."
            echo "Command to be executed: <none>"
        else
            echo "Zsh is already installed."
        fi
    fi
}

make_default_shell() {
    # Set Zsh as the default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        if [ "$1" = "--test" ]; then
            echo "Test mode: Zsh is not your default shell."
            echo "Test mode: Setting Zsh as the default shell...."
            echo 'Command to be executed: chsh -s "$(which zsh)'
            echo "Test mode: Done! do you want to log out? (y/n)"
            read -r choice
            if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
                echo 'Command to be executed: gnome-session-quit'
            fi
        else
            echo "Setting Zsh as the default shell..."
            chsh -s "$(which zsh)"
            echo "Done! Do you want to log out? (y/n)"
            read -r choice
            if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
                gnome-session-quit
            fi
        fi
    fi
}

# Main function
main() {
    # Call additional functions and logic here as needed
    check_zsh_installation "$@"
    make_default_shell "$@"
    # symlink_zshrc "$@"
    # install_ohmyzsh "$@"
    # install_ohmyzsh_plugins "$@"
    
}

# Execute main function
main "$@"
