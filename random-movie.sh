#!/bin/bash

# Get a list of all directories within the specified path
directories=(/mnt/data/media/movies/*/)

# Check if any directories exist
if [[ ${#directories[@]} -eq 0 ]]; then
  echo "No directories found in the specified path."
  exit 1
fi

# Select a random directory using a random index
random_index=$(shuf -i 0-$((${#directories[@]} - 1)) -n 1)
random_directory=${directories[$random_index]}

# Print the full path to the random directory
echo "$random_directory"
