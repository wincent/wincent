#!/bin/sh

if [ $# -eq 1 ]; then
  case $1 in
    home|work)
      "$HOME/.mutt/scripts/sync.sh" "$1" || reattach-to-user-namespace terminal-notifier -title mutt -message "~/.mutt/scripts/sync.sh ($1) exited" Enter
      exit 0
      ;;
    *)
      echo "Unrecognized argument: $1 (supported arguments: home, work)"
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

function pause() {
  PIDFILE=$1
  signal "-STOP" "$PIDFILE"
}

function resume() {
  PIDFILE=$1
  signal "-CONT" "$PIDFILE"
}

COMMAND=help
while true; do
  case $COMMAND in
    exit|exi|ex|e)
      exit
      ;;
    help|hel|he|h|\?)
      echo "Commands:"
      echo "  exit   - exit this control loop"
      echo "  help   - show this help"
      echo "  pause  - pause email sync"
      echo "  resume - resume email sync"
      echo "  sync   - force an immediate email sync"
      ;;
    pause|paus|pau|pa|p)
      echo "Pausing:"
      pause "$HOME/.mutt/tmp/sync-home.pid"
      pause "$HOME/.mutt/tmp/sync-work.pid"
      ;;
    resume|resum|resu|res|re|r)
      echo "Resuming:"
      resume "$HOME/.mutt/tmp/sync-home.pid"
      resume "$HOME/.mutt/tmp/sync-work.pid"
      ;;
    sync|syn|sy|s)
      echo "Syncing:"
      "$HOME/.mutt/scripts/download.sh" home
      "$HOME/.mutt/scripts/download.sh" work
      ;;
    *)
      echo "Invalid command: $COMMAND"
      echo "Valid commands: exit, help, pause, resume, sync"
      ;;
  esac
  /bin/echo -n "> "
  read COMMAND
done
