#!/bin/bash

# Cdd - CD extenDed
# Directory Bookmarks (with fzf)

# Installations👇
# Dependencies
# pacman -S fd fzf
# mv bmark.sh ./loacl/bin
# echo "# Directory Bookmarks && Cdd" && echo "source "$HOME"/.local/bin/bmark.sh" >> .bashrc && touch "$HOME"/config/bookmark.txt && bash
# Commands👇
#        bmark - add Directory to Bookmark list
#        cdd
#        for delete bookmark item, Edit .config/bookmark.txt

bmark() {
    cp "$HOME"/.config/bookmark.txt "$HOME"/.config/bmark.temp &&
    echo "${PWD/\/home\/nimendra\/}" >> "$HOME"/.config/bmark.temp &&
    rm "$HOME"/.config/bookmark.txt &&
    sort -g < "$HOME"/.config/bmark.temp |uniq >> "$HOME"/.config/bookmark.txt &&
    rm "$HOME"/.config/bmark.temp &&
    notify-send -t 3000 -i face-smile "Directory added to Bookmark List"
}

cdd() {
    if [ -d "$1" ]; then
        cd "$1" || return
    elif [ -f "$1" ]; then
        xdg-open "$1" || return
    else [ -z "$1" ];
        selection="$(fzf --height 75% --reverse --no-info --prompt "Select Directory  : " --bind=shift-up:preview-up,shift-down:preview-down,ctrl-j:down,ctrl-k:up --cycle --preview "fd -d 1 --base-directory $HOME/{}" < /home/nimendra/.config/bookmark.txt)" &&
        cd "$HOME/$selection" || return
    fi
}
