#!/bin/sh
# Installs screenshot-to-clipboard: screenshots go to ~/Pictures/Screenshots, and a LaunchAgent
# (local.screenshot-clipboard) copies each new one to the clipboard and moves it to the Desktop.
# ./install.sh --uninstall removes it and puts macOS screenshots back on the Desktop.
set -e
cd "$(dirname "$0")"
SCRIPT="$HOME/.local/bin/screenshot-to-clipboard.sh"
PLIST="$HOME/Library/LaunchAgents/local.screenshot-clipboard.plist"
DIR="$HOME/Pictures/Screenshots"
launchctl bootout "gui/$(id -u)/local.screenshot-clipboard" 2>/dev/null || true
if [ "$1" = "--uninstall" ]; then
  rm -f "$SCRIPT" "$PLIST"
  defaults delete com.apple.screencapture location 2>/dev/null || true
  defaults delete com.apple.screencapture show-thumbnail 2>/dev/null || true
  killall SystemUIServer 2>/dev/null || true
  echo "screenshot-to-clipboard removed; screenshots save to the Desktop again"
  exit 0
fi
mkdir -p "$HOME/.local/bin" "$HOME/Library/LaunchAgents" "$HOME/Library/Logs" "$DIR"
cp screenshot-to-clipboard.sh "$SCRIPT"
chmod +x "$SCRIPT"
# save screenshots to the staging folder, without the floating thumbnail (it delays writing the file)
defaults write com.apple.screencapture location "$DIR"
defaults write com.apple.screencapture show-thumbnail -bool false
killall SystemUIServer 2>/dev/null || true
cat > "$PLIST" <<P
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>local.screenshot-clipboard</string>
  <key>ProgramArguments</key>
  <array><string>/bin/bash</string><string>$SCRIPT</string></array>
  <key>WatchPaths</key><array><string>$DIR</string></array>
  <key>ThrottleInterval</key><integer>1</integer>
  <key>StandardErrorPath</key><string>$HOME/Library/Logs/screenshot-clipboard.log</string>
</dict>
</plist>
P
launchctl bootstrap "gui/$(id -u)" "$PLIST"
echo "screenshot-to-clipboard installed: take a screenshot (Cmd+Shift+3 / 4 / 5) and paste it anywhere"
