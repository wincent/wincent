(*
    base16 selenized-black
    Scheme author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 6168, 6168}
        set foreground color to {47545, 47545, 47545}

        -- Set ANSI Colors
        set ANSI black color to {6168, 6168, 6168}
        set ANSI red color to {60909, 19018, 17990}
        set ANSI green color to {28784, 46260, 13107}
        set ANSI yellow color to {56283, 46003, 11565}
        set ANSI blue color to {13878, 35466, 60395}
        set ANSI magenta color to {42405, 32896, 58082}
        set ANSI cyan color to {16191, 50629, 47031}
        set ANSI white color to {47545, 47545, 47545}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30583, 30583, 30583}
        set ANSI bright red color to {60909, 19018, 17990}
        set ANSI bright green color to {28784, 46260, 13107}
        set ANSI bright yellow color to {56283, 46003, 11565}
        set ANSI bright blue color to {13878, 35466, 60395}
        set ANSI bright magenta color to {42405, 32896, 58082}
        set ANSI bright cyan color to {16191, 50629, 47031}
        set ANSI bright white color to {57054, 57054, 57054}
    end tell
end tell
