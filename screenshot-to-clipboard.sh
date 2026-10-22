#!/bin/bash
# Copies the newest screenshot in ~/Pictures/Screenshots to the clipboard, then moves it to the Desktop.
# (launchd may write to ~/Desktop but not read it, so screenshots land in Pictures first.)
# Triggered by launchd (local.screenshot-clipboard) whenever the folder changes.
DIR="$HOME/Pictures/Screenshots"
STATE="$HOME/Library/Application Support/screenshot-clipboard.last"

sleep 0.3  # let screencapture finish writing
newest=$(ls -t "$DIR" 2>/dev/null | grep -iE '\.(png|jpe?g|heic|tiff?)$' | grep -v '^\.' | head -1)
[ -z "$newest" ] && exit 0
file="$DIR/$newest"
[ "$(cat "$STATE" 2>/dev/null)" = "$file" ] && exit 0
# only react to files from the last 15s, not old ones touched by other changes
[ $(( $(date +%s) - $(stat -f %m "$file") )) -gt 15 ] && exit 0

case "${newest##*.}" in
  jpg|jpeg|JPG|JPEG) cls="JPEG" ;;
  *) cls="PNGf" ;;
esac
osascript -e "set the clipboard to (read (POSIX file \"$file\") as «class $cls»)" && printf '%s' "$file" > "$STATE"
mv -n "$file" "$HOME/Desktop/$newest"
