#
# Completion
#

autoload -U compinit
compinit -u

#
# Correction
#

# exceptions to auto-correction
alias bundle='nocorrect bundle'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias sudo='nocorrect sudo'

#
# Prompt
#

autoload -U colors
colors

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%{$fg[green]%}●%{$reset_color%}" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%{$fg[red]%}●%{$reset_color%}" # default 'U'
zstyle ':vcs_info:*' formats '[%b%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'
zstyle ':vcs_info:git+set-message:*' hooks git-untracked

function +vi-git-untracked() {
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%{$fg[blue]%}●%{$reset_color%}"
  fi
}

setopt PROMPT_SUBST
export PS1="%{$fg[green]%}%m%{$reset_color%}:%{$fg[blue]%}%1~%{$fg[red]%}%(!.#.$)%{$reset_color%} "
export RPROMPT="\${vcs_info_msg_0_}%{$fg[blue]%}%~%{$reset_color%}"
export SPROMPT="zsh: correct %{$fg[red]%}'%R'%{$reset_color%} to %{$fg[red]%}'%r'%{$reset_color%} [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

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
setopt autoparamslash       # tab completing directory appends a slash
setopt clobber              # allow clobbering with >, no need to use >!
setopt correct              # command auto-correction
setopt correctall           # argument auto-correction
setopt noflowcontrol        # disable start (C-s) and stop (C-q) characters
setopt nonomatch            # unmatched patterns are left unchanged
setopt histignorealldups    # filter duplicates from history
setopt histignorespace      # don't record commands starting with a space
setopt histverify           # confirm history expansion (!$, !!, !foo)
setopt ignoreeof            # prevent accidental C-d from exiting shell
setopt interactivecomments  # allow comments, even in interactive shells
setopt printexitvalue       # for non-zero exit status
setopt sharehistory         # share history across shells

#
# Bindings
#

bindkey -e # emacs bindings, set to -v for vi bindings

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "\e[A" history-beginning-search-backward-end  # cursor up
bindkey "\e[B" history-beginning-search-forward-end   # cursor down

autoload -U select-word-style
select-word-style bash # only alphanumeric chars are considered WORDCHARS

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

#
# Other
#

source $HOME/.shells/aliases
source $HOME/.shells/common
source $HOME/.shells/exports
source $HOME/.shells/functions
source $HOME/.shells/path
source $HOME/.shells/vars

#
# Third-party
#

if which rbenv &> /dev/null; then
  eval "$(rbenv init -)"
else
  # make Bundler do passwordless installs to a sandbox rather than to the system
  export BUNDLE_PATH=~/.bundle
fi

#
# Hooks
#

autoload -U add-zsh-hook

function set-window-title() {
  print -Pn "\e]2;$1\a"
}

function set-tab-title() {
  print -Pn "\e]1;$1\a"
}

function set-tab-and-window-title() {
  print -Pn "\e]0;$1\a"
}

function update-window-title-precmd() {
  set-tab-and-window-title `history | tail -1 | cut -b8-`
}
add-zsh-hook precmd update-window-title-precmd

function update-window-title-preexec() {
  emulate -L zsh
  setopt extended_glob

  # skip ENV=settings, sudo, ssh; show first distinctive word of command;
  # mostly stolen from:
  #   https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
  set-tab-and-window-title ${2[(wr)^(*=*|ssh|sudo)]}
}
add-zsh-hook preexec update-window-title-preexec

function auto-ls-after-cd() {
  emulate -L zsh
  ls -a
}
add-zsh-hook chpwd auto-ls-after-cd

# for prompt
add-zsh-hook precmd vcs_info


# local and host-specific overrides

HOST_RC=$HOME/.zsh/host/$(hostname -s)
test -f $HOST_RC && source $HOST_RC

LOCAL_RC=$HOME/.zshrc.local
test -f $LOCAL_RC && source $LOCAL_RC
