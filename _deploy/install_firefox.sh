#!/bin/bash

url="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
output_file="/tmp/firefox.tar.bz2"

# Download the file using curl
curl -L "$url" -o "$output_file"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Firefox Developer Edition downloaded successfully."
else
  echo "Failed to download Firefox Developer Edition."
fi
