#!/bin/bash

# Check if Zsh is installed
if ! command -v zsh &> /dev/null; then
    if [ "$1" = "--test" ]; then
        echo "Test mode: Zsh is not installed."
        echo "Command to be executed: sudo apt install zsh"
    else
        echo "Zsh is not installed. Installing Zsh..."
        # Install Zsh using apt
        sudo apt install zsh
    fi
else
    if [ "$1" = "--test" ]; then
        echo "Test mode: Zsh is already installed."
        echo "Command to be executed: <none>"
    else
        echo "Zsh is already installed."
    fi
fi
