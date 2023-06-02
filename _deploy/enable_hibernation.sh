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
}

# Backup /etc/default/grub
backup_grub() {
  local source_file="/etc/default/grub"
  local backup_file="/etc/default/grub.bak"

  if [ ! -f "$source_file" ]; then
    echo "Source file $source_file not found."
    exit 1
  fi

  cp "$source_file" "$backup_file"
  if [ $? -eq 0 ]; then
    echo "Backup created successfully: $backup_file"
  else
    echo "Backup creation failed."
  fi
}

# Main function
main() {
  swap_uuid=$(get_swap_uuid)
  check_swap_uuid "$swap_uuid"
  print_swap_uuid "$swap_uuid"
  backup_grub
}

# Run the script
main
