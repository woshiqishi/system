#!/bin/bash

packages_file="$HOME/system/scripts/apt/manual_packages"

# Check if manual_packages file exists
if [ -f "$packages_file" ]; then
  # Read package names from the file
  packages=$(cat "$packages_file")

  # Install each package using sudo apt install
  if [ -n "$packages" ]; then
    echo "Installing packages:"
    echo "$packages"
    sudo apt install -y $packages
  else
    echo "No packages found in $packages_file."
  fi
else
  echo "File $packages_file not found."
fi
