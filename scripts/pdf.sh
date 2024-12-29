#!/bin/bash

# Define the search command
search_command="pdfgrep -irHn --cache strategy"

# Run the search command and extract the file paths
file_paths=$(eval "$search_command")

# Use fzf to select a file from the search results
selected_file=$(echo "$file_paths" | fzf --delimiter ':' --preview="echo {3}")

# Output the selected file path
echo "$selected_file"
