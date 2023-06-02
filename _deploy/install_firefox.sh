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

# Download the file using curl
curl -L "$url" -o "$output_file"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Firefox Developer Edition downloaded successfully."

  # Extract the tar file to /opt
  sudo tar -xvf "$output_file" -C "$extract_dir"

  # Check if the extraction was successful
  if [ $? -eq 0 ]; then
    echo "Firefox Developer Edition extracted to $extract_dir"

    # Create the shortcut file
    echo "[Desktop Entry]
Name=Firefox Developer Edition
Exec=$extract_dir/firefox
Icon=$extract_dir/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
StartupNotify=true" > "$shortcut_file"

    echo "Shortcut file created at $shortcut_file"
  else
    echo "Failed to extract Firefox Developer Edition."
    exit 1
  fi
else
  echo "Failed to download Firefox Developer Edition."
  exit 1
fi
