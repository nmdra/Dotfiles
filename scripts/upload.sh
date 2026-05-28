#!/bin/bash

file=$(fzf --reverse --header "Choose file to upload (0x0.st)")
if [[ -z "$file" ]]; then
  echo "No file selected."
  exit 1
fi

link=$(curl -s -F "file=@${file}" http://0x0.st)

echo "Uploaded: $link"

if command -v xclip >/dev/null 2>&1; then
  echo -n "$link" | xclip -selection clipboard
  echo "Copied to clipboard"
else
  echo "xclip not found. Install it to enable clipboard copying."
fi
