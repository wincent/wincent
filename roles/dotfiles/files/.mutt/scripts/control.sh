#!/bin/sh

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

echo "Control process started (type \"help\" for help):"
while true; do
  /bin/echo -n "> "
  read COMMAND
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
done
