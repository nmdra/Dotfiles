#!/bin/bash

# Name: spongebob.sh
# Dependencies: cut,fzf,MPV
# Description:
# Contributors: nimendra
# Last Update: 2023-01-13 12:05
# --------------------------------------------
# > github.com/nmdra
# > twitter.com/nimendra_


# curl https://raw.githubusercontent.com/nmdra/Dotfiles/main/other/spongebobLinks/spongebob.txt >> ~/.cache/spongebobLinks.txt

episode=$(fzf < ~/.cache/spongebobLinks.txt)

host="https://ww.megacartoons.net/video/SpongeBob-SquarePants-"
link=$(echo "$episode" | cut --delimiter=" " --fields=2)
epno=$(echo "$episode" | cut --delimiter=" " --fields=1)

RED='\033[0;31m'

echo -e "Please wait for Loading...\nEpisode:$epno\tTitle:${RED}${link//-/ }"

mpv "$host$link.mp4" 1> /dev/null 2> /dev/null

