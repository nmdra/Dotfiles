#!/bin/bash

# Script name: .bashrc
# Catogary: config
# Dependencies: bash,oh-my-bash,fzf
# Description:
# Contributors: nimendra
# Last Update: 2022-07-26 16:41
# --------------------------------------------
# > gitlab.com/nimendra_
# > twitter.com/nimendra_

# oh-my-bash{{{
# Path to your oh-my-bash installation.
export OSH=/home/nimendra/.config/oh-my-bash
OSH_THEME="font"
source $OSH/oh-my-bash.sh #}}}

#  EXPORT{{{

export TERM="xterm-256color"                      #getting proper colors
export EDITOR="nvim"
export VISUAL="nvim"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'" #pacman -S bat
if [ -n "${NVIM_LISTEN_ADDRESS+x}"]; then
    export MANPAGER="/usr/bin/nvim -c 'Man!' -o -"
fi


export HISTFILE=$HOME/.local/state/.bash_history

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export ANDROID_HOME="$XDG_DATA_HOME"/android
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export ERRFILE="$XDG_CACHE_HOME"/X11/xsession-errors

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# setxkbmap -option ctrl:nocaps
# }}}

# ex - archive extractor{{{
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
#}}}

#alias #{{{
alias ls='exa --icons'
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias lsa='exa --all --icons --long --reverse --sort=modified'
alias paclist="pacman -Slq | fzf --reverse --header "Serach_Package" --multi --preview 'pacman -Si {1}' | xclip -sel clip"
alias cmus='tmux new-session -A -D -s cmus "$(which --skip-alias cmus)"'
alias tupy='tmux new-session -s Python-session -c ~/Documents/Learning/Python_Learning/project/ -n Workflow 'nvim' \; \split-window -h -p 15 \; \split-window -v -p 40 \; new-window -n Notes \; new-window -n Other'
alias lf='lfub.sh'
# TODO list
alias td='todo.sh'
alias tdl='cat /home/nimendra/.config/todo.txt'
alias tdr='nvim /home/nimendra/.config/todo.txt'
#}}}

#FZF#{{{

[ -f ~/.config/fzf/fzf.bash ] && source ~/.config/fzf/fzf.bash

export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --height 85% --border=rounded'

export FZF_DEFAULT_COMMAND="fd -H |sed 's@^\./@@'"

export FZF_ALT_C_COMMAND="fd -H |sed 's@\./@@'"

export FZF_CTRL_T_COMMAND="fd |sed 's@^\./@@'"
#}}}

shopt -s autocd

# Bookmark & betercd Script
source "$HOME"/.local/bin/bmark.sh


complete -C /usr/bin/terraform terraform

# >>>> Vagrant command completion (start)
. /opt/vagrant/embedded/gems/gems/vagrant-2.4.2/contrib/bash/completion.sh
# <<<<  Vagrant command completion (end)
