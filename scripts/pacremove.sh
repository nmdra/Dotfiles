#!/bin/bash

# Name: pacremove
# Catogary: Bash script
# Dependencies: pacman,fzf
# Description: remove orphans package
# Contributors: nimendra
# Last Update: 2022-06-24 07:49
# --------------------------------------------
# > gitlab.com/nimendra_
# > twitter.com/nimendra_

remove="$(pacman -Qdtq | fzf -m)" &&
sudo pacman -Rs $remove
