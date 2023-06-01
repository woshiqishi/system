#!/bin/bash

bashrc_file="$HOME/.bashrc"
code_block=$(cat <<'EOF'
for file in "$HOME/system/alias"/*.sh; do
    [[ -r "$file" ]] && source "$file"
done
EOF
)

# Check if the code block exists in the .bashrc file
if grep -qF "$code_block" "$bashrc_file"; then
    echo "Code block already exists in .bashrc"
else
    # Add the code block to .bashrc
    echo -e "\n$code_block" >> "$bashrc_file"
    echo "Code block added to .bashrc"
fi
