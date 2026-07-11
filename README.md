# New Mac Setup

One-command setup: installs Homebrew, then 152 CLI tools, 35 apps,
and 33 Mac App Store apps, plus a zsh setup with the antidote plugin
manager (config in `zsh-config/`, installed to `~/.config/zsh`).

## How to run

1. On the new Mac, open Terminal and run:

   ```
   git clone https://github.com/hodgiers/mbp-onboard.git
   cd mbp-onboard
   ./install.sh
   ```

   (Or download the ZIP from GitHub — green "Code" button > Download ZIP —
   and run `./install.sh` from the unzipped folder.)

3. Accept the Xcode Command Line Tools dialog when it appears, and
   enter your password when Homebrew asks.

## 1Password CLI setup

The bundle installs the 1Password CLI (`op`), and `.aliases` contains
commented-out example functions that pull passwords from your vault
(look for the "1Password-powered helpers" section). To use them:

1. Install the 1Password desktop app (not included in the Brewfile):

   ```
   brew install --cask 1password
   ```

2. Open 1Password, sign in, then go to **Settings > Developer** and
   turn on **Integrate with 1Password CLI**.
3. Verify it works — this should prompt Touch ID, then list your vaults:

   ```
   op vault list
   ```

4. For each helper function you want, get a secret reference from the
   1Password app: open an item, click the down-arrow next to the
   password field, choose **Copy Secret Reference**, and paste it into
   the function in `~/.config/zsh/.aliases` in place of
   `op://<vault>/<item>/password`. Uncomment the function and run
   `exec zsh` to reload.

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
