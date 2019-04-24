#!/bin/bash

# Based on: https://stackoverflow.com/a/8351489/2103996
backoff() {
  local max_attempts=${ATTEMPTS-5}
  local timeout=${TIMEOUT-1}
  local attempt=1
  local exitCode=0

  while (( $attempt < $max_attempts ))
  do
    if "$@"
    then
      return 0
    else
      exitCode=$?
    fi

    echo "error: retrying in $timeout..." 1>&2
    sleep $timeout
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 2 ))
  done

  if [[ $exitCode != 0 ]]
  then
    echo "error: maximum attempt count exceeded ($@)" 1>&2
  fi

  return $exitCode
}

signal_ant() {
  SIG=$1

  PIDS=$(pgrep -f '/usr/local/bin/ant all')

  if [ -z "$PIDS" ]; then
    echo "error: \`ant all\` is not running - nothing to send $SIG to"
    exit 1
  fi

  for PID in $PIDS; do
    GROUP=$(ps -p "$PID" -o pgid | sed -e 1d -e 's/ *//')
    if [ -z "$GROUP" ]; then
      echo "error: unable to determine process group of process $PID"
      exit 1
    fi
    echo "Sending $SIG to process group $GROUP of process $PID"
    kill "-$SIG" "-$GROUP"
  done
}
