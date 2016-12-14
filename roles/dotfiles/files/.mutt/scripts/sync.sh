#!/bin/sh

set -e

if [ $# -ne 1 ]; then
  echo "error: expected exactly 1 argument, got $#"
  exit 1
fi

ACCOUNT="$1"

while true; do
  echo "Running imapfilter ($ACCOUNT):"
  echo

  ONCE=1 time imapfilter -vc "${HOME}/.imapfilter/${ACCOUNT}.lua" || {
    reattach-to-user-namespace \
      terminal-notifier -title imapfilter -message "imapfilter ($ACCOUNT) exited"
    exit 1
  }

  echo
  echo "Running mbsync ($ACCOUNT):"
  echo

  time mbsync "$ACCOUNT" || {
    reattach-to-user-namespace \
      terminal-notifier -title mbsync -message "mbsync ($ACCOUNT) exited"
    exit 1
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

  sleep 60
done
