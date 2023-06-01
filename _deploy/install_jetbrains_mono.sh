#!/bin/bash

font_directory="${HOME}/.local/share/fonts/fonts/ttf"
font_files="${font_directory}/JetBrainsMono*.ttf"

# Check if JetBrains Mono font files already exist
if ls ${font_files} >/dev/null 2>&1; then
    echo "JetBrains Mono font files already exist. Skipping installation."
else
    echo "Installing JetBrains Mono font files..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

    # Verify if the installation was successful
    if ls ${font_files} >/dev/null 2>&1; then
        echo "JetBrains Mono font files installed successfully."
    else
        echo "Failed to install JetBrains Mono font files."
    fi
fi

