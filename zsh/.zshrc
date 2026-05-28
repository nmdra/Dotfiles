# ── XDG Base Dirs (must be first — everything depends on these) ───────────────
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Ensure required dirs exist
mkdir -p "$XDG_STATE_HOME/bash" "$XDG_CACHE_HOME/X11" "$XDG_CACHE_HOME/starship"

# ── Oh-My-Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$XDG_CONFIG_HOME/.oh-my-zsh"
ZSH_THEME=""   # disabled — using Starship instead

HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_TITLE="true"
zstyle ':omz:update' mode disabled

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
  kubectl
  aws
)

source "$ZSH/oh-my-zsh.sh"

# ── Shell Options ─────────────────────────────────────────────────────────────
setopt AUTO_PUSHD           # push dirs onto stack on cd
setopt PUSHD_IGNORE_DUPS    # no duplicate dirs in stack
setopt CORRECT              # suggest corrections for commands
setopt HIST_IGNORE_ALL_DUPS # remove older duplicate history entries
setopt HIST_REDUCE_BLANKS   # strip superfluous blanks from history
setopt SHARE_HISTORY        # share history across sessions

# ── History ───────────────────────────────────────────────────────────────────
export HISTFILE="$XDG_STATE_HOME/bash/history"
export HISTSIZE=50000
export SAVEHIST=50000

# ── Locale & Term ─────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export TERM="xterm-256color"

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

if [[ -n "${NVIM_LISTEN_ADDRESS+x}" ]]; then
  export MANPAGER="/usr/bin/nvim -c 'Man!' -o -"
else
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ── Tool-specific XDG paths ───────────────────────────────────────────────────
export ANDROID_HOME="$XDG_DATA_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Go ────────────────────────────────────────────────────────────────────────
export GOENV="$XDG_CONFIG_HOME/go/env"

# ── Input Method ─────────────────────────────────────────────────────────────
export XMODIFIERS=@im=ibus

# ── auto-notify ───────────────────────────────────────────────────────────────
export AUTO_NOTIFY_THRESHOLD=15
AUTO_NOTIFY_IGNORE+=("docker" "lf" "paclist" "cdd" "fzf" "zi")

# ── Aliases ───────────────────────────────────────────────────────────────────
alias air='~/.local/bin/air'
alias ls='exa --icons'
alias lsa='exa --all --icons --long --reverse --sort=modified'
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
alias open='. open'
alias xcopy='xclip -sel clip'
alias v='nvim'

# Package management (Arch/Manjaro)
alias pacsyu='sudo pacman -Syu'
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -R'
alias paclist="pacman -Slq | fzf --reverse --header 'Search Package' --multi --preview 'pacman -Si {1}' | xclip -sel clip"

# System
alias setcharge='sudo tlp setcharge'
alias envy='envycontrol -q'
alias cpustat='auto-cpufreq --stats'
alias lf='lfub.sh'

# Network
alias convpn='protonvpn-cli connect'
alias disvpn='protonvpn-cli disconnect'

# Media
alias mpvstream='mpv --ytdl-format=worst --cache=yes --cache-secs=5'
alias ytmusic='mpv --vo=null --video=no --pause=no --no-video --term-osd-bar --term-osd-bar-chars=󰎈󰎈 --loop-playlist=inf'

# Cloud sync
alias cloneg='rclone sync --copy-links ~/Documents/Y1S2/LEARNING remote-gdrive:Y1S2/LEARNING -P -v && rclone tree remote-gdrive:'

# Pandoc via Docker
alias pandoc='docker run --rm -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/extra'

# ── FZF ───────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_DEFAULT_COMMAND="fd -H | sed 's@^\./@@'"
export FZF_ALT_C_COMMAND="fd -H | sed 's@\./@@'"
export FZF_CTRL_T_COMMAND="fd --follow | sed 's@^\./@@'"

# ── fzf-tab ───────────────────────────────────────────────────────────────────
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# ── Zoxide ────────────────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ── Terminal title ────────────────────────────────────────────────────────────
preexec() { print -Pn "\e]0;$1\a" }

# ── History queue hook ────────────────────────────────────────────────────────
zshaddhistory() {
  echo "${1%%$'\n'}" >> ~/.bash_history_queue
}

# ── Completions ───────────────────────────────────────────────────────────────
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

fpath=(/opt/vagrant/embedded/gems/gems/vagrant-2.4.2/contrib/zsh $fpath)
autoload -Uz compinit && compinit

# ── Starship prompt (must be last) ────────────────────────────────────────────
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
eval "$(starship init zsh)"
