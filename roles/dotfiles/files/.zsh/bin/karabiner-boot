#!/bin/sh

# As this script will be called from Hammerspoon where the UID
# environment variable is not set, grab the UID ourselves here if need be.
if [ -z "$UID" ]; then
  UID=$(id -u)
fi

# In Hammerspoon, $PATH will be too minimal(/usr/bin:/bin:/usr/sbin:/sbin)
# to find the `dry` executable.
PATH=$PATH:$HOME/bin

# Depends on /private/etc/sudoers.d/karabiner-sudoers:
sudo launchctl load /Library/LaunchDaemons/org.pqrs.karabiner.karabiner_grabber.plist
sudo launchctl load /Library/LaunchDaemons/org.pqrs.karabiner.karabiner_observer.plist

launchctl enable gui/"$UID"/org.pqrs.karabiner.karabiner_console_user_server
launchctl bootstrap gui/"$UID" /Library/LaunchAgents/org.pqrs.karabiner.karabiner_console_user_server.plist
launchctl enable gui/"$UID"/org.pqrs.karabiner.karabiner_console_user_server

# Turn key repeat back on:
if command -v dry &> /dev/null; then
  dry 0.033333 > /dev/null
fi

echo "🐣 Karabiner-Elements bootstrapped"
