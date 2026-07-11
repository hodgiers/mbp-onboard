# New Mac Setup

One-command setup: installs Homebrew, then 152 CLI tools, 35 apps,
and 33 Mac App Store apps, plus a zsh setup with the antidote plugin
manager (config in `zsh-config/`, installed to `~/.config/zsh`).

## How to run

1. Copy this whole folder to the new Mac (AirDrop works fine).
2. Open Terminal and run:

   ```
   cd ~/Downloads/new-mac-setup   # or wherever you put it
   ./install.sh
   ```

3. Accept the Xcode Command Line Tools dialog when it appears, and
   enter your password when Homebrew asks.

## Notes

- **App Store apps**: sign in to the App Store app first. Paid apps you
  don't own will just fail and get skipped — that's fine.
- Don't want App Store apps at all? Run `./install.sh --no-mas`.
- Safe to re-run: it skips anything already installed.
- To trim the list, open `Brewfile` in a text editor and delete lines
  you don't want before running.
- **Shell config**: any existing `~/.zshenv` / `~/.config/zsh` is backed
  up (with a `.backup-<timestamp>` suffix) before the new config is
  installed. Antidote and its plugins download themselves automatically
  the first time you open a new terminal window.
- Edit `zsh-config/zdotdir/.aliases` to taste — a few entries reference
  the original machine's paths.
