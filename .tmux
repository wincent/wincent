#!/bin/sh

set -e

SESSION=dot

if tmux has-session -t=$SESSION 2> /dev/null; then
  tmux attach -t $SESSION
  exit
fi

# 1. Main window.
tmux new-session -d -s $SESSION -n vim -x $(tput cols) -y $(tput lines)
tmux split-window -t $SESSION:vim -h
tmux send-keys -t $SESSION:vim.left "vim -c CommandT" Enter

# 2. Secondary window.
if [ -d "$DATADOG_ROOT/wincent" ]; then
  tmux new-window -t $SESSION -n ddoghq -c "$DATADOG_ROOT/wincent" -d
fi

# Give shell time to init and draw prompt.
for i in {1..5}; do
  if tmux capture-pane -p -t $SESSION:vim.right | grep -q "wincent ❯"; then
    break
  else
    sleep 0.1
  fi
done

if command -v jj > /dev/null 2>&1; then
  tmux send-keys -t $SESSION:vim.right "jj log --ignore-working-copy" Enter
fi

# BUG: Not sure when this started (maybe around my update to macOS Sequoia), we
# need a delay here otherwise the right pane winds up with some garbage escape
# sequence inserted into the pane.
sleep 0.5

tmux attach -t $SESSION:vim.right
