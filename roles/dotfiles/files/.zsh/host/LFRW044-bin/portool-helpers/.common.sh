#!/bin/sh

signal_ant() {
  SIG=$1

  PIDS=$(pgrep -f '/usr/local/bin/ant all')

  if [ -z "$PIDS" ]; then
    echo "error: \`ant all\` is not running - nothing to send $SIG to"
    exit 1
  fi

  for PID in $PIDS; do
    GROUP=$(ps -p "$PID" -o pgid | sed 1d)
    if [ -z "$GROUP" ]; then
      echo "error: unable to determine process group of process $PID"
      exit 1
    fi
    echo "Sending $SIG to process group $GROUP of process $PID"
    kill "-$SIG" "-$GROUP"
  done
}
