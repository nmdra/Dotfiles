#!/bin/bash
# Dependencies: curl,grep,whitelist,StevenBlack hosts
# Description: Simple stupid script for blocking ads.
# Last Update: 2022-06-09 13:02
# ==============================================================================

    # grep -Fvf ~/.local/bin/whitelist hosts2 > hosts

link="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/"
if [[ "$1" == "-on" ]]; then

    sudo cp ~/.cache/dison /etc/hosts &&

    notify-send -t 3000 -i face-smile  "HOST File Updated" "Distractive sites Blocked."

elif [[ "$1" == "-off" ]]; then

    sudo cp ~/.cache/disoff /etc/hosts &&

    notify-send -t 3000 -i face-smile  "HOST File Updated" "Distractive sites Unblocked"

elif [[ "$1" == "-u" ]]; then

    curl "$link"fakenews-gambling-porn-social/hosts --output ~/.cache/dison &&
    curl "$link"fakenews-gambling-porn/hosts --output ~/.cache/disoff

else
    printf "%s\n%s\n%s\n" "-on    Turn off Distractive Sites" "-off   Turn on Distractive Sites" "-u     Update host file List"

fi
