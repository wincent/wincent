(*
    base16 Sandcastle
    Scheme author: George Essig (https://github.com/gessig)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 11308, 13364}
        set foreground color to {43176, 39321, 33924}

        -- Set ANSI Colors
        set ANSI black color to {11308, 12850, 15163}
        set ANSI red color to {33667, 42405, 39064}
        set ANSI green color to {21074, 35723, 35723}
        set ANSI yellow color to {41120, 32382, 15163}
        set ANSI blue color to {33667, 42405, 39064}
        set ANSI magenta color to {55255, 24415, 24415}
        set ANSI cyan color to {33667, 42405, 39064}
        set ANSI white color to {54741, 50372, 41377}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15934, 17476, 20817}
        set ANSI bright red color to {33667, 42405, 39064}
        set ANSI bright green color to {21074, 35723, 35723}
        set ANSI bright yellow color to {41120, 32382, 15163}
        set ANSI bright blue color to {33667, 42405, 39064}
        set ANSI bright magenta color to {55255, 24415, 24415}
        set ANSI bright cyan color to {33667, 42405, 39064}
        set ANSI bright white color to {65021, 62708, 49601}
    end tell
end tell
