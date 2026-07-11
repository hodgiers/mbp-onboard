#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# Set XDG cache directory
export XDG_CACHE_DIR=${XDG_CACHE_DIR:-$HOME/.cache}
# Zsh options.
setopt extended_glob          # treat #, ~, and ^ as part of patterns for filename generation
setopt append_history         # this is default, but set for share_history
setopt hist_expire_dups_first # # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_find_no_dups      # When searching history don't show results already cycled through twice
setopt hist_ignore_dups       # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space      # remove command line from history list when first character is a space
setopt hist_reduce_blanks     # remove superfluous blanks from history items
setopt inc_append_history     # save history entries as soon as they are entered
setopt interactivecomments    # allow use of comments in interactive code (bash-style comments)
setopt longlistjobs           # display PID when suspending processes as well
setopt share_history          # share history between different instances of the shell
HISTFILE=${HOME}/.local/share/zsh/history
HISTSIZE=100000
HISTFILESIZE=
SAVEHIST=${HISTSIZE}

# Set Oh-My-Zsh environment variables
export ZSH="${XDG_CACHE_HOME:-$HOME/.cache}/antidote/ohmyzsh/ohmyzsh"
export ZSH_CACHE_DIR="${XDG_CACHE_DIR:-$HOME/.cache}/zsh"

# Set up completions directory and fpath
mkdir -p ${XDG_CACHE_DIR:-$HOME/.cache}/zsh/completions
ZFUNCDIR=${ZFUNCDIR:-$ZDOTDIR/.functions}
fpath=(
${XDG_CACHE_DIR:-$HOME/.cache}/zsh/completions
$ZFUNCDIR
$fpath
)

# Load functions
autoload -Uz $fpath[1]/*(N.:t)

# Initialize completions early
autoload -Uz compinit && compinit

# Source zstyles you might use with antidote.
[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

# Tool integrations with existence checks
if command -v direnv >/dev/null 2>&1; then
eval "$(direnv hook zsh)"
fi

if command -v op >/dev/null 2>&1; then
eval "$(op completion zsh)"
fi

if command -v register-python-argcomplete >/dev/null 2>&1; then
eval "$(register-python-argcomplete pipx)"
fi

if command -v virtualenvwrapper.sh >/dev/null 2>&1; then
source virtualenvwrapper.sh
elif [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
source /usr/local/bin/virtualenvwrapper.sh
fi

# Clone antidote if necessary.
[[ -d ${ZDOTDIR:-~}/.antidote ]] ||
git clone https://github.com/mattmc3/antidote ${ZDOTDIR:-~}/.antidote

# Create an amazing Zsh config using antidote plugins.
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

#
eval "bindkey "$terminfo[kcuu1]" history-substring-search-up"
eval "bindkey "$terminfo[kcud1]" history-substring-search-down"
MAGIC_ENTER_OTHER_COMMAND='eza --long --all --sort=modified'
if [ -f /opt/homebrew/etc/profile.d/autojump.sh ]; then
. /opt/homebrew/etc/profile.d/autojump.sh
fi
export BAT_THEME='gruvbox-dark'
#
export PATH="$HOME/.local/bin:$PATH"
