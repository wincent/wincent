(*
    base24 Alien Blood
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3855, 5654, 3855}
        set foreground color to {23130, 28527, 23644}

        -- Set ANSI Colors
        set ANSI black color to {3855, 5654, 3855}
        set ANSI red color to {32639, 11051, 9766}
        set ANSI green color to {12079, 32382, 9509}
        set ANSI yellow color to {0, 43433, 57311}
        set ANSI blue color to {12079, 26985, 32639}
        set ANSI magenta color to {18247, 22359, 32382}
        set ANSI cyan color to {12593, 32639, 30326}
        set ANSI white color to {23130, 28527, 23644}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17990, 21588, 10794}
        set ANSI bright red color to {57311, 32896, 2056}
        set ANSI bright green color to {6168, 57568, 0}
        set ANSI bright yellow color to {48573, 57568, 0}
        set ANSI bright blue color to {0, 43433, 57311}
        set ANSI bright magenta color to {0, 22616, 57311}
        set ANSI bright cyan color to {0, 57311, 50115}
        set ANSI bright white color to {29555, 63993, 37008}
    end tell
end tell
