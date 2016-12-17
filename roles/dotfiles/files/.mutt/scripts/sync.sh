#!/bin/sh

if [ $# -ne 1 ]; then
  echo "error: expected exactly 1 argument, got $#"
  exit 1
fi

ACCOUNT="$1"
BACKOFF=0
MAX_BACKOFF=480 # 8 minutes

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
  delay

  echo "Running imapfilter ($ACCOUNT):"
  echo

  ONCE=1 time imapfilter -vc "${HOME}/.imapfilter/${ACCOUNT}.lua" || {
    reattach-to-user-namespace \
      terminal-notifier -title imapfilter -message "imapfilter ($ACCOUNT) exited"
    backoff
    continue
  }

  echo
  echo "Running mbsync ($ACCOUNT):"
  echo

  time gtimeout 600 mbsync "$ACCOUNT" || {
    reattach-to-user-namespace \
      terminal-notifier -title mbsync -message "mbsync ($ACCOUNT) exited"
    backoff
    continue
  }

  echo
  echo "Running postsync hooks ($ACCOUNT):"
  echo

  time ~/.mutt/hooks/postsync/$ACCOUNT.sh # Runs notmuch, lbdb-fetchaddr etc

  echo
  echo "Updating mailboxes listing:"

  ~/.mutt/scripts/mailboxes.rb

  echo "Finished at $(date)."
  echo "Sleeping for 1m..."
  echo

  BACKOFF=0
  sleep 60
done
