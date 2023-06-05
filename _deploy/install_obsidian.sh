#!/bin/bash

# URL of the Obsidian .deb package
url='https://github.com/obsidianmd/obsidian-releases/releases/download/v1.3.5/obsidian_1.3.5_amd64.deb'
# Output file path for the downloaded package
output='/tmp/obsidian.deb'

# Function to download the Obsidian package
download() {
    if curl --location "$url" --output "$output"; then
        echo 'Obsidian downloaded!'
    else
        echo 'ERROR: Failed to download Obsidian'; exit 1
    fi
}

# Function to install the downloaded Obsidian package
install() {
    if sudo dpkg --install "$output"; then
        echo 'Obsidian installed'; rm "$output"
    else
        echo 'ERROR: Failed to install Obsidian'
        rm "$output" && exit 1
    fi
}

# Main function to orchestrate the download and installation
main() {
    download
    install
}

# Call the main function to start the script
main
