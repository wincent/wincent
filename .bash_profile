# .bash_profile for/by Wincent Colaiuta
# Copyright 2003-2009 Wincent Colaiuta
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

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

#OPENTITLEBAR="\[\033]0;"
#CLOSETITLEBAR="\007\]"

# for a long time I had \W in the title bar and \w in the prompt; now swapped
#TITLEBAR="${OPENTITLEBAR}\W${CLOSETITLEBAR}"
#TITLEBAR="${OPENTITLEBAR}\w${CLOSETITLEBAR}"

# also had \u in the prompt for a long time; dropped it
#PROMPT="${GREEN}\h:${BLUE}\w ${NOCOLOR}\u${RED}\$ ${NOCOLOR}"
PROMPT="${GREEN}\h:${BLUE}\W${RED}\$ ${NOCOLOR}"

# previously set the titlebar from the prompt
#export PS1="${TITLEBAR}${PROMPT}"
export PS1="${PROMPT}"

#
# Title bar
#

# note that is different than the version used in the old prompt-based solution
OPENTITLEBAR="\033]0;"
CLOSETITLEBAR="\007"

trap 'printf "${OPENTITLEBAR} `history 1 | cut -b8-` - `pwd` ${CLOSETITLEBAR}"' DEBUG

# this function isn't used, but will keep it around anyway
function set_title ()
{
  echo -n -e "\033]0;$*\007"
}

#
# History
#

# keep lots of commands in the history, both in memory and on disk
export HISTSIZE=10000
export HISTFILESIZE=10000

# omit consecutive duplicates from the history list
export HISTCONTROL=ignoredups

export HOSTFILE=~/.bash_hostfile

HISTIGNORE="exit"
export HISTIGNORE

#
# Shell options
#

# prevent accidental CTRL-D from exiting the shell (multiple CTRL-Ds will still work)
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

export SVKMERGE=FileMerge
export CVSROOT=/usr/local/cvsrep
export PAGER=/usr/bin/less
export EDITOR=vim

# filename (if known), line number if known, falling back to percent if known, falling back to byte offset, falling back to dash
export LESSPROMPT='?f%f .?ltLine %lt:?pt%pt\%:?btByte %bt:-...'

# F = exit immediately if fits on first screen, M = verbose prompt, R = ANSI color support, X = prevent output from being cleared
export LESS=FMRX

# for the benefit of CPAN and potentially others
export FTP_PASSIVE=1

# colour ls listings
CLICOLOR=true

# /usr/local/bin has to come first so that custom Ruby install will be used (1.8.6)
PATH=/usr/local/bin:$PATH:$HOME/bin:/Developer/Tools:/usr/X11R6/bin
PATH=$PATH:/usr/local/mysql/bin
export PATH

MANPATH=/usr/share/man:/usr/local/man:/usr/local/share/man:/usr/X11R6/man
MANPATH=$MANPATH:/usr/local/mysql/man
export MANPATH

# on attempting to "cd" search current directory first, then home dir etc
# don't export CDPATH (can cause problems with shell scripts etc)
CDPATH=.:~:~/trabajo:/usr/local

# for ANTLR
export CLASSPATH=".:/usr/local/antlr/lib/antlr-3.0.1-custom.jar"
export CLASSPATH="$CLASSPATH:/usr/local/antlr/lib/antlr-2.7.7.jar"
export CLASSPATH="$CLASSPATH:/usr/local/antlr/lib/antlr-runtime-3.0.1.jar"
export CLASSPATH="$CLASSPATH:/usr/local/antlr/lib/stringtemplate-3.1b1.jar"

#
# Aliases
#

alias m="mvim --remote-silent"

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

# the only kind of "top" listing I ever seem to do (and "top -u" is deprecated)
alias top="/usr/bin/top -ocpu -Otime"

# human readable du and df
alias du="echo -e \"${ECHORED}/usr/bin/du -h [alias]${ECHONOCOLOR}\";\
          /usr/bin/du -h"

alias df="echo -e \"${ECHORED}/bin/df -h [alias]${ECHONOCOLOR}\";\
          /bin/df -h"

alias pstree="echo -e \"${ECHORED}/usr/local/bin/pstree -w[alias]${ECHONOCOLOR}\";\
              /usr/local/bin/pstree -w"

alias mirror="/usr/local/bin/wget -H -p -k"

alias monitor_backup="pushd ${HOME}; until /usr/bin/false; do ll | grep bz2 | awk ' { print \$6 } '; sleep 60; done; popd"

alias igrep="/usr/bin/grep -i"

# enable IRB auto-completion
# NOTE: this should probably go in .irbrc, no here
alias irb="irb --readline -r irb/completion"

#
# Functions
#

inetu()
{
  test "$TERM_PROGRAM" = "Apple_Terminal" && ts novel
  ssh $1@wincent1.inetu.net
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

# prepare Synergy button set distribution archive
buttonarchive()
{
  # loop through the args
  while [ -n "$1" ]
  do
    /bin/chmod -R 644 "$1"
    /bin/chmod 755 "$1"
    /bin/rm -f "$1/.DS_Store"
    /usr/bin/touch "$1/.typeAttributes.dict"
    /bin/cp -v /dev/null "$1/Info.plist/..namedfork/rsrc"
    /bin/cp -v /dev/null "$1/nextImage.png/..namedfork/rsrc"
    /bin/cp -v /dev/null "$1/pauseImage.png/..namedfork/rsrc"
    /bin/cp -v /dev/null "$1/playImage.png/..namedfork/rsrc"
    /bin/cp -v /dev/null "$1/playPauseImage.png/..namedfork/rsrc"
    /bin/cp -v /dev/null "$1/stopImage.png/..namedfork/rsrc"
    /bin/cp -v /dev/null "$1/prevImage.png/..namedfork/rsrc"
    /bin/rm -f "$1.tar"
    /bin/rm -f "$1.tar.gz"
    /usr/bin/tar -c -v "$1" > "$1.tar"
    /usr/bin/gzip --verbose -9 "$1.tar"
    shift
  done
}

# zap resource forks
zap()
{
  # loop through the args
  while [ -n "$1" ]
  do
    /bin/cp -v /dev/null "$1/..namedfork/rsrc"
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
    /bin/cp -i -v /dev/null "$1/..namedfork/rsrc"
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

#
# Completions
#

# make directory commands see only directories
complete -d cd pushd

# unalias completes with aliases
complete -a unalias

# type, which and whereis complete on commands
complete -c type which whereis

complete -o default -A hostname nslookup host ping traceroute
complete -o default -A group chgrp
complete -o default -A user chown

#
# Other files
#

BASH_COMPLETION=~/.bash/completion/bash_completion
test -f $BASH_COMPLETION && . $BASH_COMPLETION

GIT_COMPLETION=~/.git-completion.sh
test -f $GIT_COMPLETION && . $GIT_COMPLETION
