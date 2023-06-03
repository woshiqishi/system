#!/bin/bash

# Function to check Zsh installation and execute in test mode
check_zsh_installation() {
    if ! command -v zsh &> /dev/null; then
        if [ "$1" = "--test" ]; then
            echo "Test mode: Zsh is not installed."
            echo "Command to be executed: sudo apt install zsh"
        else
            echo "Zsh is not installed. Installing Zsh..."
            sudo apt install zsh

            # Set Zsh as the default shell
            if [ "$SHELL" != "$(which zsh)" ]; then
                echo "Setting Zsh as the default shell..."
                sudo chsh -s "$(which zsh)"
            fi
        fi
    else
        if [ "$1" = "--test" ]; then
            echo "Test mode: Zsh is already installed."
            echo "Command to be executed: <none>"
        else
            echo "Zsh is already installed."

            # Set Zsh as the default shell
            if [ "$SHELL" != "$(which zsh)" ]; then
                echo "Setting Zsh as the default shell..."
                sudo chsh -s "$(which zsh)"
            fi
        fi
    fi
}

# Main function
main() {
    # Call additional functions and logic here as needed
    check_zsh_installation "$@"
}

# Execute main function
main "$@"
