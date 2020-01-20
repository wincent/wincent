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

node_path() {
  local DIR=$PWD

  local NODE_BINDIR="$HOME/code/portal/liferay-portal/build/node/bin"

  # File to use to find nearest liferay-portal checkout.
  local SENTINEL=release.properties

  while [ -n "$DIR" ]; do
    if [ -e "$DIR/$SENTINEL" ]; then
      local EXECUTABLE="$DIR/build/node/bin/node"

      if [ -x "$EXECUTABLE" ]; then
        echo "info: using $EXECUTABLE" >&2

        NODE_BINDIR="$DIR/build/node/bin"
      fi

      break
    else
      DIR=${DIR%/*}
    fi
  done

  local NODE_BINARY="$NODE_BINDIR/node"

  if [ ! -x "$NODE_BINARY" ]; then
    echo "error: no $NODE_BINARY executable" >&2
    exit 1
  fi

  echo $NODE_BINDIR
}

signal_proc() {
  SIG=$1
  TARGET=$2

  PIDS=$(pgrep -f "$TARGET")

  if [ -z "$PIDS" ]; then
    echo "error: \`$TARGET\` is not running - nothing to send $SIG to"
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
