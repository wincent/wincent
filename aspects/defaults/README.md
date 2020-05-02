# Sets up defaults (ie. preferences) on macOS.

## Future work

For a long time I had this script sitting in the root of the repo but never got around to automating it. I am not sure how much of this is still valid/necessary, so leaving it here for historical reference and possible review in the future:

```
#!/bin/sh

set -x

# [10.11.1]
defaults -currentHost write com.apple.systemuiserver dontAutoLoad -array \
  "/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu" \
  "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
  "/System/Library/CoreServices/Menu Extras/Volume.menu"

# [10.11.1]
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/TextInput.menu"

# [10.13]
# Needs attributes to be cleared:
# https://www.reddit.com/r/macsysadmin/comments/7snk0u/macos_high_sierra_unhide_the_user_library_via_cli/
xattr -d com.apple.FinderInfo ~/Library

# [10.11.1] Show the ~/Library folder
chflags nohidden ~/Library

# [10.9] Misc `systemsetup` settings: see `man systemsetup`
sudo systemsetup -settimezone US/Pacific
sudo systemsetup -setusingnetworktime on
sudo systemsetup -setcomputersleep Never
sudo systemsetup -setdisplaysleep 15
sudo systemsetup -setharddisksleep Never
sudo systemsetup -setrestartfreeze on
sudo systemsetup -setremoteappleevents off

# [10.9] Disable the sudden motion sensor as it’s not useful for SSDs
# [Probably useless; no way to verify this command works]
sudo pmset -a sms 0

# [10.9] Disable local Time Machine snapshots
sudo tmutil disable
sudo tmutil disablelocal
```
