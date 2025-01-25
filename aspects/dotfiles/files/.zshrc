#
# Start profiling (uncomment when necessary)
#
# See: https://stackoverflow.com/a/4351664/2103996

# Per-command profiling:

# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst

# Per-function profiling:

# zmodload zsh/zprof

#
# Global
#

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __WINCENT

__WINCENT[ITALIC_ON]=$'\e[3m'
__WINCENT[ITALIC_OFF]=$'\e[23m'
__WINCENT[ZSHRC]=$HOME/.zshrc
__WINCENT[REAL_ZSHRC]=${__WINCENT[ZSHRC]:A}

# ~/code/wincent, 4 levels up from ~/code/wincent/aspects/dotfiles/files/.zshrc
__WINCENT[DOTFILES]=${__WINCENT[REAL_ZSHRC]:h:h:h:h}

#
# Teh H4xx
#

if [ "$(uname)" = "Darwin" ]; then
  # Suppress unwanted Homebrew-installed stuff.
  if [ -e /usr/local/share/zsh/site-functions/_git ]; then
    mv -f /usr/local/share/zsh/site-functions/{,disabled.}_git
  fi

  # Set 60 fps key repeat rate
  #
  # Equivalent to the fatest rate acheivable with:
  #
  #     defaults write NSGlobalDomain KeyRepeat -int 1
  #
  # But doesn't require a logout and will get restored every time we open a
  # shell (for example, if somebody manipulates the slider in the UI).
  #
  # Fastest rate available from UI corresponds to:
  #
  #     defaults write NSGlobalDomain KeyRepeat -int 2
  #
  # Slowest rate available from UI corresponds to:
  #
  #     defaults write NSGlobalDomain KeyRepeat -int 120
  #
  # Values at each slider position in UI, from slowest to fastest:
  #
  # - 120 -> 2 seconds (ie. .5 fps)
  # - 90 -> 1.5 seconds (ie .6666 fps)
  # - 60 -> 1 second (ie 1 fps)
  # - 30 -> 0.5 seconds (ie. 2 fps)
  # - 12 -> 0.2 seconds (ie. 5 fps)
  # - 6 -> 0.1 seconds (ie. 10 fps)
  # - 2 -> 0.03333 seconds (ie. 30 fps)
  #
  # See: https://github.com/mathiasbynens/dotfiles/issues/687
  #
  if command -v dry &> /dev/null; then
    dry 0.0166666666667 > /dev/null
  fi
fi

#
# Autoloaded functions
#

fpath=($HOME/.zsh/functions.d $fpath)

#
# Completion
#

# Community completions from https://github.com/zsh-users/zsh-completions
fpath=($HOME/.zsh/zsh-completions/src $fpath)

# Local/custom completion sources:
fpath=($HOME/.zsh/completions $fpath)

autoload -U compinit
compinit -u

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# $CDPATH is overpowered (can allow us to jump to 100s of directories) so tends
# to dominate completion; exclude path-directories from the tag-order so that
# they will only be used as a fallback if no completions are found.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__WINCENT[ITALIC_ON]%}--- %d ---%{$__WINCENT[ITALIC_OFF]%}%b%f

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

#
# Correction
#

# exceptions to auto-correction
alias bundle='nocorrect bundle'
alias cabal='nocorrect cabal'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias stack='nocorrect stack'
alias sudo='nocorrect sudo'

#
# Prompt
#

autoload -U colors
colors

export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

#
# History
#

export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

#
# Options
#

setopt AUTO_CD                 # [default] .. is shortcut for cd .. (etc)
setopt AUTO_PARAM_SLASH        # tab completing directory appends a slash
setopt AUTO_PUSHD              # [default] cd automatically pushes old dir onto dir stack
setopt AUTO_RESUME             # allow simple commands to resume backgrounded jobs
setopt CLOBBER                 # allow clobbering with >, no need to use >!
setopt CORRECT                 # [default] command auto-correction
setopt CORRECT_ALL             # [default] argument auto-correction
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter non-contiguous duplicates from history
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_DUPS        # do filter contiguous duplicates from history
setopt HIST_IGNORE_SPACE       # [default] don't record commands starting with a space
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt IGNORE_EOF              # [default] prevent accidental C-d from exiting shell
setopt INTERACTIVE_COMMENTS    # [default] allow comments, even in interactive shells
setopt LIST_PACKED             # make completion lists more densely packed
setopt MENU_COMPLETE           # auto-insert first possible ambiguous completion
setopt NO_NOMATCH              # [default] unmatched patterns are left unchanged
setopt PRINT_EXIT_VALUE        # [default] for non-zero exit status
setopt PUSHD_IGNORE_DUPS       # don't push multiple copies of same dir onto stack
setopt PUSHD_SILENT            # [default] don't print dir stack after pushing/popping
setopt SHARE_HISTORY           # share history across shells

#
# Plug-ins
#

# NOTE: must come before zsh-history-substring-search & zsh-syntax-highlighting.
autoload -U select-word-style
select-word-style bash # only alphanumeric chars are considered WORDCHARS

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# For speed:
# https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

# NOTE: must come after select-word-style.
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Note that this will only ensure unique history if we supply a prefix
# before hitting "up" (ie. we perform a "search"). HIST_FIND_NO_DUPS
# won't prevent dupes from appearing when just hitting "up" without a
# prefix (ie. that's "zle up-line-or-history" and not classified as a
# "search"). So, we have HIST_IGNORE_DUPS to make life bearable for that
# case.
#
# https://superuser.com/a/1494647/322531
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# NOTE: must come after select-word-style.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#
# Bindings
#

bindkey -e # emacs bindings, set to -v for vi bindings

# Use "cbt" capability ("back_tab", as per `man terminfo`), if we have it:
if tput cbt &> /dev/null; then
  bindkey "$(tput cbt)" reverse-menu-complete # make Shift-tab go to previous completion
fi

if [[ $(uname -a) =~ "Ubuntu" ]]; then
  bindkey "$key[Up]" history-substring-search-up
  bindkey "$key[Down]" history-substring-search-down
else
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

edit-last-command-output() {
  if [[ "$TERM" =~ "tmux" ]]; then
    tmux capture-pane -p -S - -E - -J | tac | awk '
      found && !/❯/ { print }
      /❯/ && !found { found=1; next }
      /❯/ && found {exit}
    ' | tac | nvim -
  else
    echo
    print -Pn "%F{red}error: can't capture last command output outside of tmux%f"
    zle accept-line
  fi
}

zle -N edit-last-command-output
bindkey '^x^o' edit-last-command-output

bindkey ' ' magic-space # do history expansion on space

# Replace standard history-incremental-search-{backward,forward} bindings.
# These are the same but permit patterns (eg. a*b) to be used.
bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

# Make CTRL-Z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

# Mac-like wordwise movement (Opt/Super plus left/right) in Kitty.
bindkey "^[[1;3C" forward-word # For macOS.
bindkey "^[[1;3D" backward-word # For macOS.
bindkey "^[[1;5C" forward-word # For Arch.
bindkey "^[[1;5D" backward-word # For Arch.

#
# Other prerequisites before we set up `$PATH`.
#

test -d $HOME/n && export N_PREFIX="$HOME/n"
test -d $HOME/.volta && export VOLTA_HOME="$HOME/.volta"

#
# And before we `export` etc.
#

if [ -f "$HOME/.zsh/zsh-async/async.zsh" ]; then
  autoload -Uz async && async
fi

#
# Other
#

source $HOME/.zsh/path # Must come first! (Others depend on it.)

source $HOME/.zsh/aliases
source $HOME/.zsh/common
source $HOME/.zsh/color
source $HOME/.zsh/exports
source $HOME/.zsh/functions
source $HOME/.zsh/hash
source $HOME/.zsh/vars

#
# Third-party
#

# Skim

# test -e "$HOME/.zsh/skim/shell/key-bindings.zsh" && source "$HOME/.zsh/skim/shell/key-bindings.zsh"
test -e "$HOME/.zsh/skim/shell/completion.zsh" && source "$HOME/.zsh/skim/shell/completion.zsh"

#
# Hooks
#

autoload -U add-zsh-hook

function -set-tab-and-window-title() {
  emulate -L zsh
  local TITLE="${1:gs/$/\\$}"
  print -Pn "\e]0;$TITLE:q\a"
}

# $HISTCMD (the current history event number) is shared across all shells
# (due to SHARE_HISTORY). Maintain this local variable to count the number of
# commands run in this specific shell.
__WINCENT[HISTCMD_LOCAL]=0

function -forkless-basename() {
  emulate -L zsh
  echo "${PWD##*/}"
}

# Show first distinctive word of command (for use in tab titles).
function -title-command() {
  emulate -L zsh
  setopt EXTENDED_GLOB

  # Mostly stolen from:
  #
  #   https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
  #
  # Via `man zshall`, $2, passed into a preexec function:
  #
  #     the second argument is a single-line, size-limited version of the
  #     command (with things like function bodies elided)
  #
  # - Due to EXTENDED_GLOB, $2 will be expanded as follows.
  # - `[(wr)...]` is for array manipulation ([w]ord split, and [r]emove).
  # - `^` exclude patterns.
  # - `*=*` will remove env vars (eg. `foo=bar`, anything containing an "=").
  # - `mosh`/`ssh`/`sudo` get removed too.
  # - `-*` removes anything starting with a hyphen.
  # - `:gs/%/%%` ensures that any "%" (rare) gets escaped as "%%".
  echo "${1[(wr)^(*=*|mosh|ssh|sudo|-*)]:gs/%/%%}"
}

# Executed before displaying prompt.
function -update-title-precmd() {
  emulate -L zsh
  setopt EXTENDED_GLOB
  setopt KSH_GLOB
  if [[ __WINCENT[HISTCMD_LOCAL] -eq 0 ]]; then
    # About to display prompt for the first time; nothing interesting to show in
    # the history. Show $PWD.
    -set-tab-and-window-title "$(-forkless-basename)"
  else
    local LAST=$(fc -l -1)
    LAST="${LAST## #}" # Trim leading whitespace.
    LAST="${LAST##*([^[:space:]])}" # Remove first word (history number).
    LAST="${LAST## #}" # Trim leading whitespace.
    if [ -n "$TMUX" ]; then
      # Inside tmux, just show the last command: tmux will prefix it with the
      # session name (for context).
      -set-tab-and-window-title "$(-title-command "$LAST")"
    else
      # Outside tmux, show $PWD (for context) followed by the last command.
      -set-tab-and-window-title "$(-forkless-basename) • $(-title-command "$LAST")"
    fi
  fi
}
add-zsh-hook precmd -update-title-precmd

# Executed before executing a command: $2 is one-line (truncated) version of
# the command.
function -update-title-preexec() {
  emulate -L zsh
  __WINCENT[HISTCMD_LOCAL]=$((++__WINCENT[HISTCMD_LOCAL]))
  if [ -n "$TMUX" ]; then
    # Inside tmux, show the running command: tmux will prefix it with the
    # session name (for context).
    -set-tab-and-window-title "$(-title-command "$2")"
  else
    # Outside tmux, show $PWD (for context) followed by the running command.
    -set-tab-and-window-title "$(-forkless-basename) • $(-title-command "$2")"
  fi
}
add-zsh-hook preexec -update-title-preexec

typeset -F SECONDS
function -record-start-time() {
  emulate -L zsh
  ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}
add-zsh-hook preexec -record-start-time

function -update-ps1() {
  # Check for tmux by looking at $TERM, because $TMUX won't be propagated to any
  # nested sudo shells but $TERM will.
  local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)
  if [ -n "$TMUXING" -a -n "$TMUX" ]; then
    # In a tmux session created in a non-root or root shell.
    local LVL=$(($SHLVL - 1))
  elif [ -n "$XAUTHORITY" ]; then
    # Probably in X on Linux.
    local LVL=$(($SHLVL - 2))
  else
    # Either in a root shell created inside a non-root tmux session,
    # or not in a tmux session.
    local LVL=$SHLVL
  fi

  # OSC-133 escape sequences for prompt navigation.
  #
  # See: https://gitlab.freedesktop.org/Per_Bothner/specifications/blob/master/proposals/semantic-prompts.md
  #
  # tmux only cares about $PROMPT_START, but we emit other escapes just for
  # completeness (see also, `-mark-output()`, further down).
  local PROMPT_START=$'\e]133;A\e\\'
  local PROMPT_END=$'\e]133;B\e\\'

  # %F{green}, %F{blue}, %F{yellow} etc... = change foreground color
  # %f = turn off foreground color
  # %n = $USER
  # %m = hostname up to first "."
  # %B = bold on, %b = bold off
  local SSH_USER_AND_HOST="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b"

  # %1~ = show 1 trailing component of working directory, or "~" if is is $HOME
  local CURRENT_DIRECTORY="%F{blue}%B%1~%b"

  # Show last `tw` or `tick` step in bold yellow.
  local TW_SUMMARY="%F{yellow}%B(${TW})%b%f"

  # %(1j.*.) = bold yellow "*" if the number of jobs is at least 1
  local JOB_STATUS_INDICATOR="%F{yellow}%B%(1j.*.)%b%f"

  # %(?..!) = bold yellow "!" if the exit status of the last command was not 0
  local EXIT_STATUS_INDICATOR="%F{yellow}%B%(?..!)%b%f"

  local PROMPT_SEPARATOR=" "

  # %(!.%F{yellow}%n%f.) = if root (!) show yellow $USER, otherwise nothing.
  local USER_INDICATOR="%B%(!.%F{yellow}%n%f.)%b"

  # show one ❯ per $LVL
  local PROMPT_CHARACTERS="$(printf '\u276f%.0s' {1..$LVL})"

  # $(!.%F{yellow}.%F{red})$(...) = use bold yellow for root, otherwise bold red
  local FINAL_PROMPT_MARKER="%B%(!.%F{yellow}.%F{red})${PROMPT_CHARACTERS}%f%b"

  PS1="%{${PROMPT_START}%}"
  PS1+="${SSH_USER_AND_HOST}"
  PS1+="${CURRENT_DIRECTORY}"
  if [ -n "$GIT_COMMITTER_DATE" -a -n "$GIT_AUTHOR_DATE" -a -n "$TW" ]; then
    PS1+="${TW_SUMMARY}"
  fi
  PS1+="${JOB_STATUS_INDICATOR}"
  PS1+="${EXIT_STATUS_INDICATOR}"
  PS1+="${PROMPT_SEPARATOR}"
  PS1+="${USER_INDICATOR}"
  PS1+="${FINAL_PROMPT_MARKER}"
  PS1+="%{${PROMPT_END}%}"
  PS1+="${PROMPT_SEPARATOR}"
  export PS1

  if [[ -n "$TMUXING" ]]; then
    # Outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
    # prompt still gets corrupted even if we add an extra space to compensate.
    export ZLE_RPROMPT_INDENT=0
  fi
}
add-zsh-hook precmd -update-ps1

function -mark-output() {
  # Emit OSC 133;C (mark beginning of command output).
  builtin print -n '\e]133;C\e\\'
}
add-zsh-hook preexec -mark-output

if [ -f "$HOME/.zsh/zsh-async/async.zsh" ]; then
  # http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
  autoload -Uz vcs_info

  () {
    zstyle ':vcs_info:*' enable git hg
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr "%F{green}•%f" # default 'S'
    zstyle ':vcs_info:*' unstagedstr "%F{red}•%f" # default 'U'
    zstyle ':vcs_info:*' use-simple true
    zstyle ':vcs_info:git+set-message:*' hooks git-untracked
    zstyle ':vcs_info:git*:*' formats '[%b%m%c%u] ' # default ' (%s)-[%b]%c%u-'
    zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'
    zstyle ':vcs_info:hg*:*' formats '[%m%b] '
    zstyle ':vcs_info:hg*:*' actionformats '[%b|%a%m] '
    zstyle ':vcs_info:hg*:*' branchformat '%b'
    zstyle ':vcs_info:hg*:*' get-bookmarks true
    zstyle ':vcs_info:hg*:*' get-revision true
    zstyle ':vcs_info:hg*:*' get-mq false
    zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks
    zstyle ':vcs_info:hg*+set-message:*' hooks hg-message

    function +vi-hg-bookmarks() {
      emulate -L zsh
      if [[ -n "${hook_com[hg-active-bookmark]}" ]]; then
        hook_com[hg-bookmark-string]="${(Mj:,:)@}"
        ret=1
      fi
    }

    function +vi-hg-message() {
      emulate -L zsh

      # Suppress hg branch display if we can display a bookmark instead.
      if [[ -n "${hook_com[misc]}" ]]; then
        hook_com[branch]=''
      fi
      return 0
    }

    function +vi-git-untracked() {
      emulate -L zsh
      if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
        hook_com[unstaged]+="%F{blue}•%f"
      fi
    }
  }

  -start-async-vcs-info-worker() {
    async_start_worker vcs_info
    async_register_callback vcs_info -async-vcs-info-worker-done
  }

  -get-vcs-info-in-worker() {
    # -q stops chpwd hook from being called:
    cd -q $1
    vcs_info
    print ${vcs_info_msg_0_}
  }

  -async-vcs-info-worker-done() {
    local job=$1
    local return_code=$2
    local stdout=$3
    local more=$6
    if [[ $job == '[async]' ]]; then
      if [[ $return_code -eq 1 ]]; then
        # Corrupt worker output.
        return
      elif [[ $return_code -eq 2 || $return_code -eq 3 || $return_code -eq 130 ]]; then
        # 2 = ZLE watcher detected an error on the worker fd.
        # 3 = Response from async_job when worker is missing.
        # 130 = Async worker crashed, this should not happen but it can mean the
        # file descriptor has become corrupt.
        #
        # Restart worker.
        async_stop_worker vcs_info
        -start-async-vcs-info-worker
        return
      fi
    fi
    vcs_info_msg_0_=$stdout
    (( $more )) || zle reset-prompt
  }

  -clear-vcs-info-on-chpwd() {
    vcs_info_msg_0_=
  }

  -trigger-vcs-info-run-in-worker() {
    async_flush_jobs vcs_info
    async_job vcs_info -get-vcs-info-in-worker $PWD
  }

  -start-async-vcs-info-worker
  add-zsh-hook precmd -trigger-vcs-info-run-in-worker
  add-zsh-hook chpwd -clear-vcs-info-on-chpwd

  RPROMPT_BASE="\${vcs_info_msg_0_}%F{blue}%~%f"
  setopt PROMPT_SUBST
else
  RPROMPT_BASE="%F{blue}%~%f"
fi

function -update-rprompt() {
  emulate -L zsh
  if [ $ZSH_START_TIME ]; then
    local DELTA=$(($SECONDS - $ZSH_START_TIME))
    local DAYS=$((~~($DELTA / 86400)))
    local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
    local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
    local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
    local ELAPSED=''
    test "$DAYS" != '0' && ELAPSED="${DAYS}d"
    test "$HOURS" != '0' && ELAPSED+="${HOURS}h"
    test "$MINUTES" != '0' && ELAPSED+="${MINUTES}m"
    if [ "$ELAPSED" = '' ]; then
      SECS="$(print -f "%.2f" $SECS)s"
    elif [ "$DAYS" != '0' ]; then
      SECS=''
    else
      SECS="$((~~$SECS))s"
    fi
    ELAPSED+="${SECS}"
    export RPROMPT="%F{cyan}%{$__WINCENT[ITALIC_ON]%}${ELAPSED}%{$__WINCENT[ITALIC_OFF]%}%f $RPROMPT_BASE"
    unset ZSH_START_TIME
  else
    export RPROMPT="$RPROMPT_BASE"
  fi
}
add-zsh-hook precmd -update-rprompt

add-zsh-hook precmd bounce

function -auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ls -a
  fi
}
add-zsh-hook chpwd -auto-ls-after-cd

# adds `cdr` command for navigating to recent directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# enable menu-style completion for cdr
zstyle ':completion:*:*:cdr:*:*' menu selection

# fall through to cd if cdr is passed a non-recent dir as an argument
zstyle ':chpwd:*' recent-dirs-default true

# Local and host-specific overrides.

LOCAL_RC=$HOME/.zshrc.local
test -f $LOCAL_RC && source $LOCAL_RC

# If your hostname ever gets unset on macOS, reset with:
#   sudo scutil --set HostName $desired-host-name
HOST_RC=$HOME/.zsh/host/$(hostname -s | tr '[:upper:]' '[:lower:]')
test -f $HOST_RC && source $HOST_RC

#
# /etc/motd
#

if [ -e /etc/motd ]; then
  if ! cmp -s $HOME/.hushlogin /etc/motd; then
    tee $HOME/.hushlogin < /etc/motd
  fi
fi

#
# End profiling (uncomment when necessary)
#

# Per-command profiling:

# unsetopt xtrace
# exec 2>&3 3>&-

# Per-function profiling:

# zprof
