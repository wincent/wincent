on run argv
  set source to item 1 of argv

  set js to (read POSIX file source)

  tell application "Automator"
      set tmp to POSIX path of (path to temporary items)

      set flow to make new workflow with properties {name:tmp & "Open in Terminal Vim.app"}

      add Automator action "Run JavaScript" to flow

      set action to first Automator action of flow

      set s to first setting of action

      tell s to set value to js

      set home to POSIX path of (path to home folder)

      save flow as "application" in (home & "bin/Open in Terminal Vim.app")

      -- TODO: set icon on app

      -- TODO: maybe only quit if Automator wasn't running when we started
      quit
  end tell
end run
