#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Duplicate Chrome Tab
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./chrome.png

# Documentation:
# @raycast.description Duplicate the current tab in Chrome

tell application "Google Chrome"
  if not running then
    activate
    return "Launching Chrome"
  end if

  tell front window
    set currentTabIndex to active tab index
    set currentURL to URL of active tab

    make new tab at after tab (currentTabIndex) with properties {URL:currentURL}
  end tell

  return "Tab duplicated"
end tell
