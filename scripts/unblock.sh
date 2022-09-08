#!/bin/bash

# Name: unblock.sh
# Catogary: bash Script
# Dependencies: curl,grep,whitelist,StevenBlack hosts
# Description: Simple stupid script for blocking ads.
# Contributors: nimendra
# Last Update: 2022-06-09 13:06
# --------------------------------------------
# > gitlab.com/nimendra_
# > twitter.com/nimendra_

curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts --output hosts &&

sudo cp hosts /etc &&

rm -f hosts &&

notify-send -t 3000 -i face-smile  "HOST File Updated" "fakenews-gambling-porn blocked with ads."
