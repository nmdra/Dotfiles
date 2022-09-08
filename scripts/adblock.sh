#!/bin/bash
#      _   ________  _________
#     / | / /  _/  |/  / ____/    Name: Adblock.sh
#    /  |/ // // /|_/ / __/       Catogary: bash Script
#   / /|  // // /  / / /___       Dependencies: curl,grep,whitelist,StevenBlack hosts
#  /_/ |_/___/_/  /_/_____/       Description: Simple stupid script for blocking ads.
#      _   ______  ____  ___      Contributors: nimendra
#     / | / / __ \/ __ \/   |     Last Update: 2022-06-09 13:02
#    /  |/ / / / / /_/ / /| |     --------------------------------------------
#   / /|  / /_/ / _, _/ ___ |     > gitlab.com/nimendra_
#  /_/ |_/_____/_/ |_/_/  |_|     > twitter.com/nimendra_

# ==============================================================================

curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts --output hosts2

grep -Fvf ~/.local/bin/whitelist hosts2 > hosts

sudo cp hosts /etc

rm -f hosts

sudo rm hosts2

notify-send -t 3000 -i face-smile  "HOST File Updated" "fakenews-gambling-porn-social blocked with ads."
