#
# Completion
#

autoload -U compinit
compinit
source ~/.git-completion.sh

#
# Aliases
#

alias ....='cd ../..'
alias b=bundle
alias be=bundle exec
alias cd..='cd ..'
alias g=git
alias l='ls -F'
alias ll='ls -laF'

#
# Prompt
#

autoload -U colors
colors
export PS1="%{$fg[green]%}%m%{$reset_color%}:%{$fg[blue]%}%1~%{$fg[red]%}%(!.#.$)%{$reset_color%} "

#
# History
#

export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

#
# Options
#
setopt autocd               # .. is shortcut for cd .. (etc)
setopt correct              # command auto-correction
setopt correctall           # argument auto-correction
unsetopt flowcontrol        # disable start (C-s) and stop (C-q) characters
setopt histignorealldups    # filter duplicates from history
setopt histignorespace      # don't record commands starting with a space
setopt histverify           # confirm history expansion (!$, !!, !foo)
setopt ignoreeof            # prevent accidental C-d from exiting shell
setopt interactivecomments  # allow comments, even in interactive shells
setopt sharehistory         # share history across shells

#
# Bindings
#

bindkey -e # emacs bindings, set to -v for vi bindings
bindkey "\e[A" history-search-backward  # cursor up
bindkey "\e[B" history-search-forward   # cursor down
