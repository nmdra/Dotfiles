#!/bin/bash

[ -z "$1" ] && echo "ToDo Empty!! Try Again.." && exit

echo "($(date "+%b-%d  %I:%M%p")) 😊 $1" >> "$HOME"/.config/todo.txt &&
notify-send "Todo Added."


