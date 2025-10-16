(*
    base16 OceanicNext
    Scheme author: https://github.com/voronianski/oceanic-next-color-scheme
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 11051, 13364}
        set foreground color to {49344, 50629, 52942}

        -- Set ANSI Colors
        set ANSI black color to {13364, 15677, 17990}
        set ANSI red color to {60652, 24415, 26471}
        set ANSI green color to {39321, 51143, 38036}
        set ANSI yellow color to {64250, 51400, 25443}
        set ANSI blue color to {26214, 39321, 52428}
        set ANSI magenta color to {50629, 38036, 50629}
        set ANSI cyan color to {24415, 46003, 46003}
        set ANSI white color to {52685, 54227, 57054}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20303, 23387, 26214}
        set ANSI bright red color to {60652, 24415, 26471}
        set ANSI bright green color to {39321, 51143, 38036}
        set ANSI bright yellow color to {64250, 51400, 25443}
        set ANSI bright blue color to {26214, 39321, 52428}
        set ANSI bright magenta color to {50629, 38036, 50629}
        set ANSI bright cyan color to {24415, 46003, 46003}
        set ANSI bright white color to {55512, 57054, 59881}
    end tell
end tell
