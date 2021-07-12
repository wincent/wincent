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
