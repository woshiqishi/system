#!/bin/bash

directory="$HOME/system/_deploy"

echo

# Change to the directory
cd "$directory" || exit

# Find and execute bash scripts
find . -type f -name "*.sh" -exec bash {} \;

echo
