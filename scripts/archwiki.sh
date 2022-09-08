#!/usr/bin/env bash

# Script name: Archwiki.sh
# Catogary: Bash Script
# Dependencies: arch-wiki offline,fzf
# Description: (source:- Derek Traylor's DMScripts)
# Contributors: nimendra
# Last Update: 2022-06-09 12:49
# --------------------------------------------
# > gitlab.com/nimendra_
# > twitter.com/nimendra_

wikidocs="$(fd --base-directory /home/nimendra/.local/share/arch-wiki/html/en | sed -e 's/_/ /g' -e 's/.html//g' |sed 's@\./@@'| sort -g | fzf)"

article=$(printf '%s\n'"/home/nimendra/.local/share/arch-wiki/html/en/${wikidocs}.html" | sed 's/ /_/g') &&

librewolf "$article"
