#!/bin/bash

url="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
output_file="/tmp/firefox.tar.bz2"
extract_dir="/opt"
shortcut_file="$HOME/.local/share/applications/firefox.desktop"
addons_zip="$HOME/system/dotfiles/firefox/addons.zip"
prefs_js="$HOME/system/dotfiles/firefox/prefs.js"
profile_dir="$HOME/.mozilla/firefox"

cleanup() {
  # Clean up the downloaded file
  rm "$output_file"
  echo "Downloaded file cleaned up."
}

# Set up trap to call cleanup function on script exit or error
trap cleanup EXIT ERR

check_existence() {
  # Check if Firefox is installed through snap or apt
  if snap list firefox &> /dev/null || dpkg -s firefox &> /dev/null; then
    sudo snap remove firefox || sudo apt-get --purge remove firefox
  fi
}

install_dependencies() {
  local missing_packages=()

  # Check for missing dependencies
  for package in curl tar; do
    if ! dpkg -s "$package" > /dev/null 2>&1; then
      missing_packages+=("$package")
    fi
  done

  if [ "${#missing_packages[@]}" -gt 0 ]; then
    echo "Installing missing dependencies: ${missing_packages[*]}"
    sudo apt-get update &&
      sudo apt-get install -y "${missing_packages[@]}" ||
      { echo "Failed to install missing dependencies. Exiting."; exit 1; }
  fi
}

download_firefox() {
  # Download the file using curl
  if curl --location "$url" --output "$output_file"; then
    echo "Firefox Developer Edition downloaded successfully."

    # Extract the tar file to /opt
    if sudo tar --extract --verbose --file "$output_file" --directory "$extract_dir"; then
      echo "Firefox Developer Edition extracted to $extract_dir"

      # Create the shortcut file
      echo "[Desktop Entry]
Name=Firefox Developer Edition
Exec=$extract_dir/firefox/firefox -P wasp
Icon=$extract_dir/firefox/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
StartupNotify=true" | sudo tee "$shortcut_file" > /dev/null

      echo "Shortcut file created at $shortcut_file"

      # Create a new profile named "wasp" without launching Firefox
      "$extract_dir/firefox/firefox" -CreateProfile "wasp"

      echo "New profile 'wasp' created."

      # Find the directory ending with .wasp under the profile directory
      wasp_dir=$(find "$profile_dir" -type d -name "*.wasp" -print -quit)

      if [ -n "$wasp_dir" ]; then
        # Unzip the contents of addons.zip into the found .wasp directory
        unzip -oq "$addons_zip" -d "$wasp_dir"

        echo "Addons unzipped into the profile directory."

        # Create a symlink of prefs.js
        ln -sf "$prefs_js" "$wasp_dir"

        echo "Symlink created for prefs.js."
      else
        echo "No .wasp directory found."
      fi
    else
      echo "Failed to extract Firefox Developer Edition."
      exit 1
    fi
  else
    echo "Failed to download Firefox Developer Edition."
    exit 1
  fi
}

main() {
  check_existence
  install_dependencies
  download_firefox
}

main
