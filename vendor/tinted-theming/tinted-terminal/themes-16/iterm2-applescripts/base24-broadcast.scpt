(*
    base24 Broadcast
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11051, 11051, 11051}
        set foreground color to {52171, 52171, 52171}

        -- Set ANSI Colors
        set ANSI black color to {11051, 11051, 11051}
        set ANSI red color to {56026, 18761, 14649}
        set ANSI green color to {20817, 40863, 20560}
        set ANSI yellow color to {40863, 52942, 61680}
        set ANSI blue color to {28013, 40092, 48830}
        set ANSI magenta color to {53456, 53456, 65535}
        set ANSI cyan color to {28270, 40092, 48830}
        set ANSI white color to {52171, 52171, 52171}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25957, 25957, 25957}
        set ANSI bright red color to {65535, 31611, 27499}
        set ANSI bright green color to {33667, 53713, 33410}
        set ANSI bright yellow color to {65535, 65535, 31868}
        set ANSI bright blue color to {40863, 52942, 61680}
        set ANSI bright magenta color to {65535, 65535, 65535}
        set ANSI bright cyan color to {41120, 52942, 61680}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
