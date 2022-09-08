#!/usr/bin/env bash
# Common directories functions
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
# alias ...='cd ../../'                       # Go back 2 directory levels
# alias .3='cd ../../../'                     # Go back 3 directory levels
# alias .4='cd ../../../../'                  # Go back 4 directory levels
# alias .5='cd ../../../../../'               # Go back 5 directory levels
# alias .6='cd ../../../../../../'            # Go back 6 directory levels

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
# alias rd='rmdir'
alias d='dirs -v | head -10'

# List directory contents

### ALIASES ###

# pacman and yay
alias pacsyu='sudo pacman -Syyu --disable-download-timeout'                 #update
alias pacs='sudo pacman -S '                      #install
alias pacr='sudo pacman -R'
alias yaysua="sudo yay -Sua"
# confirm before overwriting something
alias cp="cp -i "
alias mv='mv -i'
alias rm='rm '

# youtube-dl
alias ytdlpls="yt-dlp -F "
alias ytdlpdown="yt-dlp -f "

#SpotDL
alias spotdlflac="spotdl --output-format flac --lyrics-provider musixmatch "
alias spotd="spotdl --output-format mp3 --lyrics-provider genius"

#Powermenu
alias reboot="sudo reboot "
alias shutdown="sudo shutdown "

# git
alias addall='git add .'
alias clone='git clone'
alias commit='git commit -m'
alias push='git push origin'
alias stat='git status'  # 'status' is protected name so using 'stat' instead

# ProtonVPN
alias convpn="protonvpn-cli connect"
alias disvpn="protonvpn-cli disconnect"
alias revpn="protonvpn-cli reconnect"
alias statvpn="protonvpn-cli status"
alias configvpn="protonvpn-cli config"
alias loginvpn="protonvpn-cli login"
alias logoutvpn="protonvpn-cli logout"

# Auto-CpuFreq & TLP
alias cpustat="sudo auto-cpufreq --stats"
alias tlpstat="tlp-stat -s"


# TimeShift
alias timeshift="sudo timeshift --check"
alias timeshiftls="sudo timeshift --list"
alias timeshiftcreate="sudo timeshift --create"

# Other
alias pkglist="pacman -Qqe > my-config-manjaro/pkglist.txt"
alias cd="cd "
alias mpv="mpv "
alias vim="nvim "

alias version="cat /etc/lsb-release"
alias free="free -h"

