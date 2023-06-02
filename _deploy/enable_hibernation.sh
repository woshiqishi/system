#!/bin/bash

# Get the UUID of the swap partition
get_swap_uuid() {
  blkid -o value -s UUID -t TYPE=swap
}

# Check if the swap UUID is empty
check_swap_uuid() {
  local swap_uuid=$1

  if [ -z "$swap_uuid" ]; then
    echo "Swap partition not found or not configured."
    exit 1
  fi
}

# Print the UUID of the swap partition
print_swap_uuid() {
  local swap_uuid=$1

  echo "UUID of the swap partition: $swap_uuid"
  read -p "Is the UUID correct? (y/n): " answer

  if [[ $answer != "y" ]]; then
    echo "UUID is not confirmed. Exiting..."
    exit 1
  fi
}

# Backup /etc/default/grub
backup_grub() {
  local source_file="/etc/default/grub"
  local backup_file="/etc/default/grub.bak2"

  if [ ! -f "$source_file" ]; then
    echo "Source file $source_file not found."
    exit 1
  fi

  sudo cp "$source_file" "$backup_file"
  if [ $? -eq 0 ]; then
    echo "Backup created successfully: $backup_file"
  else
    echo "Backup creation failed."
  fi
}

# Replace the specified line in /etc/default/grub
replace_grub_line() {
  local source_file="/etc/default/grub"
  local swap_uuid=$1

  sudo sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"resume=UUID=$swap_uuid\"/" "$source_file"
  if [ $? -eq 0 ]; then
    echo "Line replaced successfully in $source_file"
  else
    echo "Line replacement failed."
  fi
}

# Main function
main() {
  swap_uuid=$(get_swap_uuid)
  check_swap_uuid "$swap_uuid"
  print_swap_uuid "$swap_uuid"
  backup_grub
  replace_grub_line "$swap_uuid"
}

# Run the script
main
