(*
    base16 OneDark Dark
    Scheme author: olimorris (https://github.com/olimorris)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {43947, 45746, 49087}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {61423, 22873, 28527}
        set ANSI green color to {35209, 51914, 30840}
        set ANSI yellow color to {58853, 49344, 31611}
        set ANSI blue color to {24929, 44975, 61423}
        set ANSI magenta color to {54741, 24415, 57054}
        set ANSI cyan color to {11051, 47802, 50629}
        set ANSI white color to {43947, 45746, 49087}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17219, 18504, 21074}
        set ANSI bright red color to {61423, 22873, 28527}
        set ANSI bright green color to {35209, 51914, 30840}
        set ANSI bright yellow color to {58853, 49344, 31611}
        set ANSI bright blue color to {24929, 44975, 61423}
        set ANSI bright magenta color to {54741, 24415, 57054}
        set ANSI bright cyan color to {11051, 47802, 50629}
        set ANSI bright white color to {51400, 52428, 54484}
    end tell
end tell
