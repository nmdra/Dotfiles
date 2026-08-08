#!/bin/bash
#
# config.sh — Sync dotfiles from $HOME into this repo
# Run from $HOME: bash Documents/Dotfiles/scripts/config.sh
#

set -euo pipefail

DOTFILES="$HOME/Documents/Dotfiles"

# ─── System Info ──────────────────────────────────────────────────────────────

cat /etc/lsb-release >"$DOTFILES/Sysinfo.txt"
uname -a >>"$DOTFILES/Sysinfo.txt"
echo "✓ Sysinfo created"

# ─── Package List ─────────────────────────────────────────────────────────────

pacman -Qqe >"$DOTFILES/pkglist.txt"
echo "✓ Package list created"

# ─── Shell ────────────────────────────────────────────────────────────────────

rsync ~/.bashrc "$DOTFILES/bash/"
rsync ~/.bash_profile "$DOTFILES/bash/"
rsync -r --delete ~/.config/oh-my-bash/ "$DOTFILES/bash/oh-my-bash/"
rsync ~/.zshrc "$DOTFILES/zsh/"
rsync ~/.config/starship.toml "$DOTFILES/zsh/starship.toml"

# ─── Terminal ─────────────────────────────────────────────────────────────────

rsync ~/.config/alacritty/alacritty.toml "$DOTFILES/alacritty/"
rsync ~/.config/ghostty/config "$DOTFILES/ghostty/config"

# ─── Editors & Tools ─────────────────────────────────────────────────────────

rsync -r --delete ~/.config/nvim/ "$DOTFILES/nvim/"
rsync -r --delete ~/.config/lf/ "$DOTFILES/lf/"
rsync -r --delete ~/.config/zathura/ "$DOTFILES/zathura/"
rsync -r --delete ~/.config/mpv/ "$DOTFILES/mpv/"
rsync ~/.config/tmux/tmux.conf "$DOTFILES/tmux/"
rsync -r --delete ~/.config/neofetch/ "$DOTFILES/neofetch/"

# ─── Agent Skills, Workflows & Pi Config ─────────────────────────────────────
# Secrets/runtime never synced: auth.json, models-store.json, sessions/,
# run-history.jsonl, usage-extension-cache.json, npm/

rsync -r --delete ~/.agents/skills/ "$DOTFILES/.agents/skills/"
rsync -r --delete ~/.agents/rules/ "$DOTFILES/.agents/rules/"
rsync -r --delete ~/.agents/workflows/ "$DOTFILES/.agents/workflows/"
rsync -r --delete ~/.pi/agent/skills/ "$DOTFILES/.pi/agent/skills/"
rsync -r --delete ~/.pi/agent/agents/ "$DOTFILES/.pi/agent/agents/"
rsync -r --delete ~/.pi/agent/prompts/ "$DOTFILES/.pi/agent/prompts/"
rsync -r --delete ~/.pi/agent/extensions/ "$DOTFILES/.pi/agent/extensions/" --exclude pi-permission-system
rsync ~/.pi/agent/settings.json "$DOTFILES/.pi/agent/settings.json"
rsync ~/.pi/agent/APPEND_SYSTEM.md "$DOTFILES/.pi/agent/APPEND_SYSTEM.md"
rsync ~/.pi/agent/subagents.json "$DOTFILES/.pi/agent/subagents.json"
rsync ~/.pi/agent/trust.json "$DOTFILES/.pi/agent/trust.json"
rsync ~/.pi/agent/web-search.json "$DOTFILES/.pi/agent/web-search.json"
echo "✓ Agent skills and pi config synced"

# ─── Desktop Environment ─────────────────────────────────────────────────────

rsync ~/.config/kglobalshortcutsrc "$DOTFILES/kde/Shortcuts.kksrc"

# ─── X11 ──────────────────────────────────────────────────────────────────────

rsync ~/.xinitrc "$DOTFILES/x11/"

# ─── Scripts ──────────────────────────────────────────────────────────────────

rsync ~/.local/bin/*.sh "$DOTFILES/scripts/"
rsync ~/.local/bin/ccc "$DOTFILES/scripts/"
rsync ~/.local/bin/tmux-sessionizer "$DOTFILES/scripts/"
rsync ~/.local/bin/open-zathura "$DOTFILES/scripts/"
rsync ~/.local/bin/pan "$DOTFILES/scripts/"

echo "✓ Rsync completed"

# ─── Cleanup ──────────────────────────────────────────────────────────────────

rm -rf "$DOTFILES/mpv/watch_later"
rm -f "$DOTFILES/nvim/lazy-lock.json"
rm -rf "$DOTFILES/nvim/.git"
echo "✓ Cleaned up unessentials"

notify-send "📦 Config Sync" "Dotfiles synced — ready to commit!"
