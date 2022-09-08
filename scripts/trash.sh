#!/bin/bash

selection="$(fd -d 1 | fzf -m --height 75% --reverse --no-info --prompt "Select Directory: " --cycle --preview "ls {}")"

trash-put $selection
