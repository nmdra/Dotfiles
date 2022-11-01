#!/bin/bash

img="$(fzf)"

quality="$(printf "100\n90\n80\n70\n60\n50\n40\n30" | fzf)"

file="$(printf ".jpeg\n.png\n.pdf" | fzf)"
# echo $img
# echo $quality
# echo $file
convert -quality $quality $img $img$file

# TODO

# remove .filetype
# rename with "con"
# more filetypes

