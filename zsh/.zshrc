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
    fzf-tab
    golang
)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"
# eval "$(zoxide init --cmd cd zsh)"

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
export GOPATH="$HOME"/go
# export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export ERRFILE="$XDG_CACHE_HOME"/X11/xsession-errorst

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

#}}}

# alias #{{{

DATE=$(date -I)

alias air='~/go/bin/air'
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
alias mpvstream='mpv -ytdl-format=worst -cache=yes --cache-secs=5'
alias ytmusic="mpv --vo=null --video=no --pause=no --no-video --term-osd-bar --term-osd-bar-chars=󰎈󰎈 --loop-playlist=inf "
alias cloneg='rclone sync --copy-links ~/Documents/Y1S2/LEARNING remote-gdrive:Y1S2/LEARNING -P -v && rclone tree remote-gdrive:'
alias pandoc='docker run --rm -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/extra'
alias open='. open'
alias kube='kubectl'
#}}}

#FZF{{{
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_DEFAULT_COMMAND="fd -H |sed 's@^\./@@'"

export FZF_ALT_C_COMMAND="fd -H |sed 's@\./@@'"

export FZF_CTRL_T_COMMAND="fd --follow |sed 's@^\./@@'"

#}}}

# fzf-tab
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# preexec() { print -Pn "\e]0;$1%~\a" } # Command + Directory
preexec() { print -Pn "\e]0;$1\a" } # Command

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/.oh-my-zsh/custom/.p10k.zsh ]] || source ~/.config/.oh-my-zsh/custom/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


PATH=~/.console-ninja/.bin:$PATH

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
