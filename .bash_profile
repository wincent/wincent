# Copyright 2003-2010 Wincent Colaiuta. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

#
# Colors
#
# Ironically, the best documentation for the colour codes is to be found
# in man tcsh (see LS_COLORS)

# colours for use in prompts
RED="\[\e[0;31m\]"
GREEN="\[\e[0;32m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
PURPLE="\[\e[0;35m\]"
CYAN="\[\e[0;36m\]"

BRIGHTRED="\[\e[1;31m\]"
BRIGHTBLUE="\[\e[1;34m\]"
BRIGHTCYAN="\[\e[1;36m\]"

NOCOLOR="\[\e[0m\]"

# colours for use in echo -e statements
ECHORED="\e[0;31m"
ECHONOCOLOR="\e[0m"

#
# Prompt
#

export PS1="${GREEN}\h:${BLUE}\W${RED}\$ ${NOCOLOR}"

#
# History
#

# keep lots of commands in the history, both in memory and on disk
export HISTSIZE=10000
export HISTFILESIZE=10000

# omit consecutive duplicates from the history list
export HISTCONTROL=ignoredups

export HOSTFILE=~/.bash_hostfile
export HISTIGNORE="exit"


#
# Shell options
#

# prevent accidental CTRL-D from exiting the shell (multiple CTRL-Ds will still
# work)
set -o ignoreeof

# silently correct typos in directory names when using the "cd" builtin
shopt -s cdspell

# append to the history file rather than overwriting it
shopt -s histappend

# allow user to verify that a history substitution is correct before executing
shopt -s histverify

# use extended globbing (for example, needed in the _man() function)
shopt -s extglob

# don't use host completion on words containing the "@" symbol (because it
# interferes with my ssh completion below)
shopt -u hostcomplete

#
# Environment
#

export PAGER=less
export EDITOR=vim

# filename (if known), line number if known, falling back to percent if known,
# falling back to byte offset, falling back to dash
export LESSPROMPT='?f%f .?ltLine %lt:?pt%pt\%:?btByte %bt:-...'

# F = exit immediately if fits on first screen, M = verbose prompt, R = ANSI
# color support, X = prevent output from being cleared
export LESS=FMRX

# for the benefit of CPAN and potentially others
export FTP_PASSIVE=1

# colour ls listings
export CLICOLOR=true

# for Amazon Web Services EC2 API
export EC2_HOME=~/bin/ec2-api-tools
export EC2_PRIVATE_KEY=~/.ssh/ec2wincent_pk.pem
export EC2_CERT=~/.ssh/ec2wincent_cert.pem
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

# make Bundler do passwordless installs to a sandbox rather than to the system
export BUNDLE_PATH=~/.bundle

# usually something like:
#   /usr/bin
#   /bin
#   /usr/sbin
#   /sbin
#   /usr/local/bin
#   /usr/texbin
#   /usr/X11/bin
#   /usr/local/sbin
SYSTEM_PATH=$PATH
unset PATH

# keep these on separate lines to make changing their order easier
PATH=$PATH:$HOME/.bundle/bin
PATH=$PATH:$HOME/bin
PATH=$PATH:$SYSTEM_PATH
PATH=$PATH:/usr/local/mysql/bin
PATH=$PATH:/usr/local/jruby/bin
PATH=$PATH:/Developer/Tools
PATH=$PATH:$EC2_HOME/bin
export PATH

MANPATH=/usr/share/man:/usr/local/man:/usr/local/share/man:/usr/X11R6/man
MANPATH=$MANPATH:/usr/local/mysql/man:$HOME/share/man
export MANPATH

# for hg
export PYTHONPATH=/usr/local/lib/python2.5/site-packages

# on attempting to "cd" search current directory first, then home dir etc
# don't export CDPATH (can cause problems with shell scripts etc)
CDPATH=.:~:~/trabajo:/usr/local

#
# Title bar
#

# note that is different than the version used in the old prompt-based solution
OPENTITLEBAR="\033]0;"
CLOSETITLEBAR="\007"

trap 'printf "${OPENTITLEBAR} `history 1 | cut -b8-` - `pwd` ${CLOSETITLEBAR}"' DEBUG

#
# Aliases
#

# shortcut to the bestest editor in the world
alias m="mvim --remote-silent"

alias yuicompressor='java -jar ~/trabajo/vendor/yuicompressor/yuicompressor.jar'

# distinguish folders in ls listings
alias ls="/bin/ls -F"
alias l="/bin/ls -F"

# ll = long listing (full details)
alias ll="/bin/ls -laoF"

alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."

# my single most frequent typo:
alias cd..="cd .."

alias h="history"

alias mirror="wget -H -p -k"

alias monitor_backup="pushd ${HOME}; until false; do ll | grep bz2 | awk ' { print \$6 } '; sleep 60; done; popd"

alias igrep="grep -i"

alias b="bundle exec"

#
# Functions
#

inetu()
{
  test "$TERM_PROGRAM" = "Apple_Terminal" && ts novel
  if [ -z "$1" ]; then
    ssh wincent1.inetu.net
  else
    ssh $1@wincent1.inetu.net
  fi
  test "$TERM_PROGRAM" = "Apple_Terminal" && ts wincent
}


# grep for "TODO" string
todo()
{
  if [ $# -lt 1 ]; then
    grep -R -n "TODO: " . | grep -v ".svn"
  else
    # loop through the args
    while [ -n "$1" ]
    do
      grep -R -n "TODO: " "$1" | grep -v ".svn"
      shift
    done
  fi
}

# grep for "BUG" string
bugs()
{
  if [ $# -lt 1 ]; then
    grep -R -n "BUG: " . | grep -v ".svn"
  else
    # loop through the args
    while [ -n "$1" ]
    do
      grep -R -n "BUG: " "$1" | grep -v ".svn"
      shift
    done
  fi
}

# check current directory for files with CR line endings
# requires Bash 3.0 (regular expressions)
check_cr()
{
  # execute in subshell (temporarily overriding IFS)
  (IFS="
"
  for FILE in $(find . -type f)
  do
    TYPE=$(file -b "$FILE")
    if [[ "$TYPE" =~ 'text' ]]; then
      if ! perl -ne "exit 1 if m/\r/;" "$FILE"; then
        echo "CR detected in : $FILE"
      else
        echo "ok             : $FILE"
      fi
    else
      echo "not a text file: $FILE"
    fi
  done)
}

# zap resource forks
zap()
{
  # loop through the args
  while [ -n "$1" ]
  do
    cp -v /dev/null "$1/..namedfork/rsrc"
    shift
  done
}

# count number of lines of source code in a directory
countsource()
{
  # if no argument supplied, count current directory
  if [ ! -n "$1" ]; then
    find . \( \( \( \( -name "*.[chm]" -or -name "*.cpp" \) -or -name "*.mm" \) -or -name "*.pm" \) -or -name "*.pl" \)  \
      -print0 | xargs -0 wc -l
  else
    # loop through args: note they have to be directories or it won't work
    while [ -n "$1" ]
    do
      echo "Counting lines of source code in: $1"
      find "$1" \( \( \( \( -name "*.[chm]" -or -name "*.cpp" \) -or -name "*.mm" \) -or -name "*.pm" \) -or -name "*.pl" \) \
        -print0 | xargs -0 wc -l
      shift
    done
  fi
}

# get pid of named command(s)
pid()
{
  while [ -n "$1" ]
  do
    ps axww -o pid,command | grep -i "$1" | grep -v grep | awk '{print $1}'
    shift
  done
}

# sr = strip resource fork(s) .. aliases are basically useless in bash
sr()
{
  while [ -n "$1" ]
  do
    cp -i -v /dev/null "$1/..namedfork/rsrc"
    shift
  done
}

# regmv = regex + mv (mv with regex parameter specification)
#   example: regmv '/\.tif$/.tiff/' *
#   replaces .tif with .tiff for all files in current dir
#   must quote the regex otherwise "\." becomes "."
# limitations: ? doesn't seem to work in the regex, nor *

regmv()
{
  if [ $# -lt 2 ]; then
    echo "  Usage: regmv 'regex' file(s)"
    echo "  Where:       'regex' should be of the format '/find/replace/'"
    echo "Example: regmv '/\.tif\$/.tiff/' *"
    echo "   Note: Must quote/escape the regex otherwise \"\.\" becomes \".\""
    return 1
  fi
  regex="$1"
  shift
  while [ -n "$1" ]
  do
    newname=`echo "$1" | sed "s${regex}g"`
    if [ "${newname}" != "$1" ]; then
      mv -i -v "$1" "$newname"
    fi
    shift
  done
}

get()
{
  (cd $HOME/work/unversioned && make get)
}

put()
{
  (cd $HOME/work/unversioned && make put)
}

#
# Completions
#

BASH_COMPLETION=~/.bash/completion/bash_completion
test -f $BASH_COMPLETION && . $BASH_COMPLETION

GIT_COMPLETION=~/.git-completion.sh
test -f $GIT_COMPLETION && . $GIT_COMPLETION

# whereis completes on commands
# (not so useful seeing as whereis only searches standard binary dirs, not user
# PATH)
complete -c command whereis

# Third-party
if [[ -s /Users/wincent/.rvm/scripts/rvm ]] ; then source /Users/wincent/.rvm/scripts/rvm ; fi
