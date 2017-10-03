#!/bin/sh

if [ $# -eq 1 ]; then
  case $1 in
    home|work)
      "$HOME/.mutt/scripts/sync.sh" "$1" || terminal-notifier -title mutt -message "~/.mutt/scripts/sync.sh ($1) exited" Enter
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

function term() {
  PIDFILE=$1
  signal "-TERM" "$PIDFILE"
}

function pause() {
  PIDFILE=$1
  signal "-STOP" "$PIDFILE"
}

function resume() {
  PIDFILE=$1
  signal "-CONT" "$PIDFILE"
}

function invalid() {
  echo "Invalid command: $COMMAND"
  echo "Valid commands: exit, help, pause, resume, sync"
}

set -f # Avoid wildcard expansion.

COMMAND=help
while true; do
  case $COMMAND in
    exit|exi|ex|e)
      exit
      ;;
    help|hel|he|h|\?)
      echo "Commands:"
      echo "  exit               - exit this control loop"
      echo "  help               - show this help"
      echo "  pause [home|work]  - pause email sync"
      echo "  resume [home|work] - resume email sync"
      echo "  sync [home|work]   - force an immediate email sync"
      echo "  term [home|work]   - terminate an email sync"
      ;;
    pause|paus|pau|pa|p)
      echo "Pausing:"
      if [ -n "$TARGET" ]; then
        pause "$HOME/.mutt/tmp/sync-${TARGET}.pid"
      else
        pause "$HOME/.mutt/tmp/sync-home.pid"
        pause "$HOME/.mutt/tmp/sync-work.pid"
      fi
      ;;
    resume|resum|resu|res|re|r)
      echo "Resuming:"
      if [ -n "$TARGET" ]; then
        resume "$HOME/.mutt/tmp/sync-${TARGET}.pid"
      else
        resume "$HOME/.mutt/tmp/sync-home.pid"
        resume "$HOME/.mutt/tmp/sync-work.pid"
      fi
      ;;
    sync|syn|sy|s)
      echo "Syncing:"
      if [ -n "$TARGET" ]; then
        "$HOME/.mutt/scripts/download.sh" $TARGET
      else
        "$HOME/.mutt/scripts/download.sh" home
        "$HOME/.mutt/scripts/download.sh" work
      fi
      ;;
    term|ter|te|t)
      echo "Terminating:"
      if [ -n "$TARGET" ]; then
        term "$HOME/.mutt/tmp/sync-${TARGET}.pid"
      else
        term "$HOME/.mutt/tmp/sync-home.pid"
        term "$HOME/.mutt/tmp/sync-work.pid"
      fi
      ;;
    *)
      invalid
      ;;
  esac
  while true; do
    /bin/echo -n "> "
    read -a INPUT
    if [ ${#array[@]} -gt 2 ]; then
      invalid
      continue
    fi
    COMMAND=${INPUT[0]}
    TARGET=${INPUT[1]}
    if [ -n "$TARGET" ]; then
      if [ "$TARGET" != "home" -a "$TARGET" != "work" ]; then
        echo "Invalid target: $TARGET"
        echo "Valid targets: home, work"
        continue
      fi
    fi
    break
  done
done
