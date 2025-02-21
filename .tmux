#!/bin/sh

set -e

if tmux has-session -t=dot 2> /dev/null; then
  tmux attach -t dot
  exit
fi

tmux new-session -d -s dot -n vim -x $(tput cols) -y $(tput lines)

tmux split-window -t dot:vim -h

tmux send-keys -t dot:vim.right "git --no-pager status" Enter
tmux send-keys -t dot:vim.left "vim -c CommandT" Enter

# BUG: Not sure when this started (maybe around my update to macOS Sequoia), we
# need a delay here otherwise the right pane winds up with some garbage escape
# sequence inserted into the pane.
sleep 0.5

tmux attach -t dot:vim.right
