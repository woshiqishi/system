#!/bin/bash

url="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
output_file="/tmp/firefox.tar.bz2"
extract_dir="/opt/firefox"
shortcut_file="$HOME/.local/share/applications/firefox.desktop"

cleanup() {
  # Clean up the downloaded file
  rm "$output_file"
  echo "Downloaded file cleaned up."
}

# Set up trap to call cleanup function on script exit or error
trap cleanup EXIT ERR

# Check for and install missing dependencies
dependencies=("curl" "tar")
missing_packages=()

for package in "${dependencies[@]}"; do
  if ! dpkg -s "$package" > /dev/null 2>&1; then
    missing_packages+=("$package")
  fi
done

if [ "${#missing_packages[@]}" -gt 0 ]; then
  echo "Installing missing dependencies: ${missing_packages[*]}"
  sudo apt-get update
  if ! sudo apt-get install -y "${missing_packages[@]}"; then
    echo "Failed to install missing dependencies. Exiting."
    exit 1
  fi
fi

# Download the file using curl
if curl \
  --location "$url" \
  --output "$output_file"; then
  echo "Firefox Developer Edition downloaded successfully."

  # Extract the tar file to /opt
  if sudo tar \
    --extract \
    --verbose \
    --file "$output_file" \
    --directory "$extract_dir"; then
    echo "Firefox Developer Edition extracted to $extract_dir"

    # Create the shortcut file
    echo "[Desktop Entry]
Name=Firefox Developer Edition
Exec=$extract_dir/firefox
Icon=$extract_dir/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
StartupNotify=true" | sudo tee "$shortcut_file" > /dev/null

    echo "Shortcut file created at $shortcut_file"

    # Create a new profile named "wasp" without launching Firefox
    $extract_dir/firefox -CreateProfile "wasp"

    echo "New profile 'wasp' created."

    # Unzip the contents of addons.zip into the new profile directory
    unzip -q "$HOME/system/dotfiles/firefox/addons.zip" -d "$HOME/.mozilla/firefox/wasp"

    echo "Addons unzipped into the profile directory."

    # Create a symlink of prefs.js
    ln -sf "$HOME/system/dotfiles/firefox/prefs.js" "$HOME/.mozilla/firefox/wasp/"

    echo "Symlink created for prefs.js."
  else
    echo "Failed to extract Firefox Developer Edition."
    exit 1
  fi
else
  echo "Failed to download Firefox Developer Edition."
  exit 1
fi
