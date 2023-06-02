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
    echo "Running sudo update-grub"
    sudo update-grub
    if [ $? -eq 0 ]; then
      echo "Grub successfully updated."
    else
      echo "Grub update failed."
    fi
  else
    echo "Line replacement failed."
  fi
}

# Modify the HibernateMode line in /etc/systemd/sleep.conf
modify_hibernate_mode() {
  local file="/etc/systemd/sleep.conf"
  local line="HibernateMode=shutdown"

  if grep -q '^HibernateMode=' "$file"; then
    sudo sed -i "s/^HibernateMode=.*/$line/" "$file"
    if [ $? -eq 0 ]; then
      echo "Line replaced successfully in $file"
    else
      echo "Line replacement failed."
    fi
  else
    echo "$line" | sudo tee -a "$file" >/dev/null
    if [ $? -eq 0 ]; then
      echo "Line appended successfully to $file"
    else
      echo "Line append failed."
    fi
  fi
}

# Main function
main() {
  swap_uuid=$(get_swap_uuid)
  check_swap_uuid "$swap_uuid"
  print_swap_uuid "$swap_uuid"
  backup_grub
  replace_grub_line "$swap_uuid"
  modify_hibernate_mode
}

# Run the script
main
