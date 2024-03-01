#!/bin/bash
cat /etc/lsb-release > ~/Documents/Dotfiles/Sysinfo.txt
uname -a > ~/Documents/Dotfiles/Sysinfo.txt
echo "sysinfo created"

pacman -Qqe > Documents/Dotfiles/pkglist.txt

echo "package list created"

# rsync -r -v  .config  Documents/Dotfiles > Scriptslog/"Rsync `date +"%Y-%m-%d %T"`".log

rsync .bashrc ~/Documents/Dotfiles/bash
rsync .bash_profile Documents/Dotfiles/bash
rsync .xinitrc Documents/Dotfiles/other
# rsync -r .local/share/applications Documents/Dotfiles/other
rsync .config/tmux/tmux.conf Documents/Dotfiles/tmux
rsync -r .local/bin/*.sh Documents/Dotfiles/scripts
rsync .local/bin/ccc Documents/Dotfiles/scripts
rsync -r ~/.config/alacritty/alacritty.toml ~/Documents/Dotfiles/alacritty/
rsync -r .config/zathura Documents/Dotfiles/other
rsync -r .config/lf Documents/Dotfiles
rsync -r .config/oh-my-bash Documents/Dotfiles/bash
rsync -r ~/.config/sxhkd ~/Documents/Dotfiles/other
rsync -r ~/.config/neofetch ~/Documents/Dotfiles/other
rsync -r .config/nvim Documents/Dotfiles
rsync -r .config/mpv ~/Documents/Dotfiles
rsync .zshrc ~/Documents/Dotfiles/zsh
rsync .ideavimrc ~/Documents/Dotfiles/other

echo "rsync Completed"

rm -rf Documents/Dotfiles/mpv/watch_later
rm -rf Documents/Dotfiles/.config/git
rm -r Documents/Dotfiles/nvim/lazy-lock.json
echo "removing unessentials"

notify-send "📦 Config Sync" "Ready to git pull..."

