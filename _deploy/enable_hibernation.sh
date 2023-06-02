#!/bin/bash

# Get the UUID of the swap partition
swap_uuid=$(blkid -o value -s UUID -t TYPE=swap)

# Check if the swap UUID is empty
if [ -z "$swap_uuid" ]; then
  echo "Swap partition not found or not configured."
  exit 1
fi

# Print the UUID of the swap partition
echo "UUID of the swap partition: $swap_uuid"
