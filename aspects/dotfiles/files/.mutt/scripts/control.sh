#!/bin/sh

if [ $# -eq 1 ]; then
  case $1 in
    --daemon)
      "$HOME/.mutt/scripts/sync.sh" "$1" || terminal-notifier -title mutt -message "~/.mutt/scripts/sync.sh ($1) exited" Enter
      exit 0
      ;;
    *)
      echo "Unrecognized argument: $1 (supported arguments: --daemon)"
      exit 1
      ;;
  esac
elif [ $# -ne 0 ]; then
  echo "Expected 0 or 1 arguments, got $#"
  exit 1
fi

function signal() {
  SIGNAL=$1
  PIDFILE=$2
  if [ -f "$PIDFILE" ]; then
    PID=`cat "$PIDFILE"`
    kill "$SIGNAL" "$PID"
    echo "Sent $SIGNAL signal to PID $PID ($PIDFILE)"
  else
    echo "No signal sent (missing $PIDFILE)"
  fi
}

function term() {
  PIDFILE=$1
  signal "-TERM" "$PIDFILE"
}

# Named `kill9` to avoid collision with `kill` utility.
function kill9() {
  PIDFILE=$1
  signal "-KILL" "$PIDFILE"
}

function pause() {
  PIDFILE=$1
  signal "-STOP" "$PIDFILE"
}

function resume() {
  PIDFILE=$1
  signal "-CONT" "$PIDFILE"
}

set -f # Avoid wildcard expansion.

COMMAND=help
while true; do
  case $COMMAND in
    download|downloa|downlo|downl|down|dow|do|d)
      echo "Downloading:"
      "$HOME/.mutt/scripts/download.sh"
      ;;
    exit|exi|ex|e)
      exit
      ;;
    help|hel|he|h|\?)
      echo "Commands:"
      echo "  download - force an immediate INBOX sync"
      echo "  exit     - exit this control loop"
      echo "  help     - show this help"
      echo "  kill     - kill (-9) email sync"
      echo "  pause    - pause email sync"
      echo "  resume   - resume email sync"
      echo "  sync     - force an immediate full sync"
      echo "  term     - terminate (TERM) email sync"
      ;;
    pause|paus|pau|pa|p)
      echo "Pausing:"
      pause "$HOME/.mutt/tmp/sync.pid"
      ;;
    resume|resum|resu|res|re|r)
      echo "Resuming:"
      resume "$HOME/.mutt/tmp/sync.pid"
      ;;
    sync|syn|sy|s)
      echo "Syncing:"
      "$HOME/.mutt/scripts/download.sh" Everything
      ;;
    term|ter|te|t)
      echo "Terminating:"
      term "$HOME/.mutt/tmp/sync.pid"
      ;;
    kill|kil|ki|k)
      echo "Killing:"
      kill9 "$HOME/.mutt/tmp/sync.pid"
      ;;
    *)
      echo "Invalid command: $COMMAND"
      echo "Valid commands: exit, help, pause, resume, sync, term"
      ;;
  esac
  while true; do
    /bin/echo -n "> "
    read -a INPUT
    if [ ${#INPUT[@]} -gt 1 ]; then
      echo "Invalid input: ${INPUT[@]}"
      echo "See \"help\" for usage information"
      continue
    fi
    COMMAND=${INPUT[0]}
    break
  done
done
