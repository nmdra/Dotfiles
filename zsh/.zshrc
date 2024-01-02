if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

HYPHEN_INSENSITIVE="true"

 zstyle ':omz:update' mode disabled  # disable automatic updates
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    fzf
    sudo
    auto-notify
    you-should-use
    aliases
    forgit
)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export AUTO_NOTIFY_THRESHOLD=15
AUTO_NOTIFY_IGNORE+=("docker" "lf" "paclist" "cdd" "fzf" "zi")

#  EXPORT{{{

export TERM="xterm-256color"                      #getting proper colors
export EDITOR="nvim"
export VISUAL="nvim"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'" #pacman -S bat
if [ -n "${NVIM_LISTEN_ADDRESS+x}"]; then
    export MANPAGER="/usr/bin/nvim -c 'Man!' -o -"
fi

# export HISTFILE=$HOME/.local/state/.bash_history
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export HISTFILE="${XDG_STATE_HOME}"/bash/history
export ANDROID_HOME="$XDG_DATA_HOME"/android
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export ERRFILE="$XDG_CACHE_HOME"/X11/xsession-errorst

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

#}}}

# alias #{{{

DATE=$(date -I)

alias ls='exa --icons'
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias lsa='exa --all --icons --long --reverse --sort=modified'
alias paclist="pacman -Slq | fzf --reverse --header "Serach_Package" --multi --preview 'pacman -Si {1}' | xclip -sel clip"
alias lf='lfub.sh'
alias setcharge='sudo tlp setcharge'
alias envy='envycontrol -q'
alias cpustat='auto-cpufreq --stats'
alias pacsyu='sudo pacman -Syu'
alias pacs='sudo pacman -S '
alias pacr='sudo pacman -R '
alias v='nvim'
alias convpn='protonvpn-cli connect'
alias disvpn='protonvpn-cli disconnect'
alias ytmusic="mpv --vo=null --video=no --pause=no --no-video --term-osd-bar --term-osd-bar-chars=󰎈󰎈 --loop-playlist=inf "
alias cloneg='rclone sync --copy-links ~/Documents/Y1S2/LEARNING remote-gdrive:Y1S2/LEARNING -P -v && rclone tree remote-gdrive:'
alias pandoc='docker run --rm -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/extra'
#}}}

#FZF{{{
export FZF_DEFAULT_OPTS='--color=fg:#a0a8cd,bg:#11121d,hl:#f7768e --color=fg+:#f8f8f2,bg+:#44475a,hl+:#f7768e --color=info:#ffb86c,prompt:#50fa7b,pointer:#7aa2f7 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --height 85% --border=rounded'

export FZF_DEFAULT_COMMAND="fd -H |sed 's@^\./@@'"

export FZF_ALT_C_COMMAND="fd -H |sed 's@\./@@'"

export FZF_CTRL_T_COMMAND="fd |sed 's@^\./@@'"

#}}}

# preexec() { print -Pn "\e]0;$1%~\a" } # Command + Directory
preexec() { print -Pn "\e]0;$1\a" } # Command

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/.oh-my-zsh/custom/.p10k.zsh ]] || source ~/.config/.oh-my-zsh/custom/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

