# screenshot-to-clipboard

**Every macOS screenshot is copied to the clipboard and saved to the Desktop, both at once.**

Take a screenshot with **⌘⇧3**, **⌘⇧4** or **⌘⇧5** as usual. It's instantly on your clipboard, ready to paste into WhatsApp, Slack, an email or a chat with an AI, *and* saved as a file on your Desktop.

## Why it matters

macOS makes you choose:

- **⌘⇧4** saves a file, but then you have to find it and drag it where you need it.
- **⌃⌘⇧4** copies to the clipboard, but there's no file, so once you copy something else the screenshot is gone.

Most of the time you want both: paste it right now, and keep the file for later. With this you never have to think about which shortcut to use.

It also turns off the floating thumbnail in the corner, which otherwise delays the file being saved by several seconds.

## How it works

- macOS saves screenshots to a staging folder, `~/Pictures/Screenshots`.
- A LaunchAgent watches that folder. When a new screenshot appears, a small script copies the image to the clipboard (PNG, or JPEG for .jpg files) and then moves the file to your Desktop.
- **Why not save straight to the Desktop?** macOS privacy protection stops background jobs from *reading* the Desktop folder, but they may still *move files into* it. So the screenshot is staged in Pictures, copied, then moved.
- It only reacts to files from the last 15 seconds and never handles the same file twice, so other changes in the folder are ignored.
- No app, no menu-bar icon, nothing running in between screenshots. launchd starts the script only when the folder changes.

## Install

```bash
git clone https://github.com/nvark1996/screenshot-to-clipboard.git
cd screenshot-to-clipboard
./install.sh
```

Take a screenshot and paste with **⌘V** to try it.

**Uninstall** (also puts macOS screenshots back on the Desktop as before):

```bash
./install.sh --uninstall
```

## Files

| File | What it does |
|---|---|
| `screenshot-to-clipboard.sh` | Copies the newest screenshot to the clipboard, then moves it to the Desktop |
| `install.sh` | Sets the screenshot folder, turns off the thumbnail, installs the script and the LaunchAgent; `--uninstall` undoes everything |

Log: `~/Library/Logs/screenshot-clipboard.log`

## License

MIT. See [LICENSE](LICENSE).
