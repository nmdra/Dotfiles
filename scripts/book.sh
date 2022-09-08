#!/bin/bash
# Name: book.sh
# Catogary: bash script
# Dependencies: fd,cut,fzf,zathura
# Description:
# Contributors: nimendra
# Last Update: 2022-07-31 08:29
# --------------------------------------------
# > gitlab.com/nimendra_
# > twitter.com/nimendra_

book=$(fd -a -e epub -e pdf -e cbr -e cbz  |cut -d '/' -f4- | sort -b -d | fzf --reverse --prompt "Search Book:")
[ -f "$book" ] &&
xdg-open "/home/nimendra/$book"

