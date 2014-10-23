#
# Colors
#
# Ironically, the best documentation for the colour codes is to be found
# in man tcsh (see LS_COLORS)

# colours for use in prompts
GREEN='\[\e[0;32m\]'
BLUE='\[\e[0;34m\]'
RED='\[\e[0;31m\]'
NOCOLOR='\[\e[0m\]'

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

source $HOME/.shells/exports
source $HOME/.shells/path
source $HOME/.shells/vars
source $HOME/.shells/common

#
# Title bar
#

OPENTITLEBAR="\033]0;"
CLOSETITLEBAR="\007"

trap 'printf "${OPENTITLEBAR}`history 1 | cut -b8- | sed 's/%/%%/g'`${CLOSETITLEBAR}"' DEBUG

source $HOME/.shells/aliases

#
# Functions
#

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

source $HOME/.shells/functions

#
# Completions
#

BASH_COMPLETION=~/.bash/completion/bash_completion
test -f $BASH_COMPLETION && . $BASH_COMPLETION

GIT_COMPLETION=~/.bash/git-completion.sh
test -f $GIT_COMPLETION && . $GIT_COMPLETION

# whereis completes on commands
# (not so useful seeing as whereis only searches standard binary dirs, not user
# PATH)
complete -c command whereis

#
# Third-party
#

# make Bundler do passwordless installs to a sandbox rather than to the system
export BUNDLE_PATH=~/.bundle
