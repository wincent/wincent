#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Chrome Tab
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./chrome.png

# Documentation:
# @raycast.description Create new tab to the right of the current tab in Chrome

tell application "Google Chrome"
  if not running then
    activate
    return "Launching Chrome"
  end if

  tell front window
    set currentTabIndex to active tab index
    set currentURL to URL of active tab

    make new tab at after tab (currentTabIndex)
  end tell

  return "Tab created"
end tell
