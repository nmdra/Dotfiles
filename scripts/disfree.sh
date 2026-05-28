#!/bin/bash
# Dependencies: curl, notify-send

CACHE_DIR="$HOME/.cache/host-blocker"
ON_FILE="$CACHE_DIR/dison"
OFF_FILE="$CACHE_DIR/disoff"
URL_ON="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts"
URL_OFF="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn/hosts"

choice="${1,,}"

update_lists() {
  echo "Fetching latest StevenBlack host files..."
  if curl -sL "$URL_ON" --output "$ON_FILE" && curl -sL "$URL_OFF" --output "$OFF_FILE"; then
    notify-send -t 3000 -i face-smile "Update Complete" "Host lists downloaded successfully."
    echo "Update successful."
  else
    echo "Error: Failed to download host files. Check your internet connection."
    exit 1
  fi
}

mkdir -p "$CACHE_DIR"

if [[ ! -f "$ON_FILE" || ! -f "$OFF_FILE" ]]; then
  echo "Host files not found in cache. Initializing setup..."
  update_lists
fi

case "$choice" in
-on)
  sudo cp "$ON_FILE" /etc/hosts &&
    notify-send -t 3000 -i face-smile "HOST File Updated" "Distractive sites Blocked (Focus Mode ON)."
  ;;

-off)
  sudo cp "$OFF_FILE" /etc/hosts &&
    notify-send -t 3000 -i face-smile "HOST File Updated" "Distractive sites Unblocked (Relax Mode)."
  ;;

-u)
  update_lists
  ;;

*)
  printf "Usage: %s [OPTION]\n\n" "$(basename "$0")"
  printf "  -on    Turn ON distraction blocking\n"
  printf "  -off   Turn OFF distraction blocking\n"
  printf "  -u     Update host file lists from GitHub\n"
  ;;
esac
