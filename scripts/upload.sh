#!/bin/bash
test=$(fzf --reverse --header "Choose file to Upload(0x0.st)") &&
echo "$test" | xargs -I {} curl -F "file=@{}" http://0x0.st
