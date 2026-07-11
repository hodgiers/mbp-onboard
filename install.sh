#!/bin/bash
#
# New Mac auto-setup
# Usage: ./install.sh          (installs everything)
#        ./install.sh --no-mas (skips Mac App Store apps)
#
set -u

BREWFILE="$(cd "$(dirname "$0")" && pwd)/Brewfile"
SKIP_MAS=false
[[ "${1:-}" == "--no-mas" ]] && SKIP_MAS=true

bold() { printf "\n\033[1m%s\033[0m\n" "$1"; }

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi

if [[ ! -f "$BREWFILE" ]]; then
  echo "Brewfile not found next to this script. Keep install.sh and Brewfile in the same folder." >&2
  exit 1
fi

# 1. Xcode Command Line Tools (needed by Homebrew; the brew installer
#    triggers this too, but doing it first makes the flow smoother)
if ! xcode-select -p >/dev/null 2>&1; then
  bold "Installing Xcode Command Line Tools — accept the dialog that pops up..."
  xcode-select --install
  until xcode-select -p >/dev/null 2>&1; do sleep 10; done
fi

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/brew ]]; then
  bold "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew on PATH for this run and future shells (Apple Silicon path)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  if ! grep -q 'brew shellenv' ~/.zprofile 2>/dev/null; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  fi
fi

command -v brew >/dev/null 2>&1 || { echo "Homebrew install failed." >&2; exit 1; }

# 3. Mac App Store sign-in check
if ! $SKIP_MAS && grep -q '^mas ' "$BREWFILE"; then
  bold "This bundle includes Mac App Store apps."
  echo "Sign in to the App Store app first (App Store > Sign In), or they will fail."
  read -rp "Press Enter when signed in, or type 's' to skip App Store apps: " ans
  [[ "$ans" == "s" ]] && SKIP_MAS=true
fi

# 4. Zsh config + antidote plugin manager
SETUP_DIR="$(dirname "$BREWFILE")"
if [[ -d "$SETUP_DIR/zsh-config" ]]; then
  bold "Installing zsh config (antidote plugin manager, aliases, prompt)..."
  ts=$(date +%Y%m%d%H%M%S)
  [[ -f ~/.zshenv ]] && cp ~/.zshenv ~/.zshenv.backup-$ts
  cp "$SETUP_DIR/zsh-config/zshenv" ~/.zshenv
  mkdir -p ~/.config
  [[ -d ~/.config/zsh ]] && mv ~/.config/zsh ~/.config/zsh.backup-$ts
  cp -R "$SETUP_DIR/zsh-config/zdotdir" ~/.config/zsh
  # keep the brew PATH line we added earlier in the new login profile
  grep -q 'brew shellenv' ~/.config/zsh/.zprofile 2>/dev/null ||
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.config/zsh/.zprofile
  echo "Antidote and its plugins will install themselves the first time you open a new terminal."
fi

# 5. Install everything
bold "Installing packages from Brewfile (this can take a while)..."
if $SKIP_MAS; then
  grep -v '^mas ' "$BREWFILE" > /tmp/Brewfile.nomas
  brew bundle --file=/tmp/Brewfile.nomas
else
  brew bundle --file="$BREWFILE"
fi
STATUS=$?

bold "Done."
if [[ $STATUS -ne 0 ]]; then
  echo "Some items failed (paid App Store apps you don't own are the usual culprit)."
  echo "Re-run this script any time — it skips things already installed."
fi
