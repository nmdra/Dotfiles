#!/bin/bash
# Dependencies: curl,grep,whitelist,StevenBlack hosts
# Description: Simple stupid script for blocking ads.
# Last Update: 2022-06-09 13:02
# ==============================================================================

# grep -Fvf ~/.local/bin/whitelist hosts2 > hosts

choice="${1,,}"

if [[ $choice == "-on" ]]; then

  sudo cp ~/.cache/dison /etc/hosts &&
    notify-send -t 3000 -i face-smile "HOST File Updated" "Distractive sites Blocked."

elif [[ $choice == "-off" ]]; then

  sudo cp ~/.cache/disoff /etc/hosts &&
    notify-send -t 3000 -i face-smile "HOST File Updated" "Distractive sites Unblocked"

elif [[ $choice == "-u" ]]; then
  curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts --output ~/.cache/dison &&
    curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn/hosts --output ~/.cache/disoff

else
  printf "%s\n%s\n%s\n" "-On    Turn off Distractive Sites" "-Off   Turn on Distractive Sites" "-U     Update host file List"

fi
