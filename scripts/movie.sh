#!/bin/bash

# Name: movie.sh
# Catogary: bash script
# Dependencies: fd,cut,fzf,mpv
# Contributors: nimendra
# Last Update: 2022-06-22 15:06
# --------------------------------------------
# > gitlab.com/nimendra_
# > twitter.com/nimendra_

video="$(fd -E Pictures -E Documents -a -e mp4 -e mkv |cut -d '/' -f4- | fzf --reverse --prompt "Search Movie & Tv: ")"
[ -f "$video" ] &&
xdg-open /home/nimendra/"$video"


