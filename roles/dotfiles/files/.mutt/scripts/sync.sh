#!/bin/sh

BACKOFF=0
MAX_BACKOFF=480 # 8 minutes

PIDFILE="$HOME/.mutt/tmp/sync.pid"
echo $$ > "$PIDFILE"
trap "rm -f '$PIDFILE'; exit" SIGTERM

function delay() {
  if [ $BACKOFF -ne 0 ]; then
    echo "Backing off for ${BACKOFF}s."
    sleep $BACKOFF
  fi
}

function backoff() {
  if [ $BACKOFF -eq 0 ]; then
    BACKOFF=60
  elif [ $BACKOFF -ge $MAX_BACKOFF ]; then
    BACKOFF=$MAX_BACKOFF
  else
    BACKOFF=$(expr $BACKOFF '*' 2)
  fi
}

while true; do
  if [ -x "${HOME}/.mutt/hooks/presync.sh" ]; then
    "${HOME}/.mutt/hooks/presync.sh" || {
      echo "Presync hook exited with status $?; skipping sync."
      sleep 60
      BACKOFF=0
      continue
    }
  fi

  delay

  echo "Running imapfilter:"
  echo

  ONCE=1 time imapfilter -v || {
    terminal-notifier -title imapfilter -message "imapfilter exited"
    backoff
    continue
  }

  echo
  echo "Running mbsync:"
  echo

  time gtimeout 3600 mbsync Everything || {
    terminal-notifier -title mbsync -message "mbsync exited"
    backoff
    continue
  }

  echo
  echo "Running postsync hooks:"
  echo

  time ~/.mutt/hooks/postsync.sh # Runs notmuch, lbdb-fetchaddr etc

  echo
  echo "Updating mailboxes listing:"

  ~/.mutt/scripts/mailboxes.rb

  echo "Finished at $(date)."
  echo "Sleeping for 1m..."
  echo

  BACKOFF=0
  sleep 60
done
