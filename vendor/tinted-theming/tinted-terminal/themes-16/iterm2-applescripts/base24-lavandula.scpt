(*
    base24 Lavandula
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {1285, 0, 5140}
        set foreground color to {25700, 23901, 28527}

        -- Set ANSI Colors
        set ANSI black color to {1285, 0, 5140}
        set ANSI red color to {31868, 5397, 9509}
        set ANSI green color to {13107, 32382, 28527}
        set ANSI yellow color to {36494, 34438, 57311}
        set ANSI blue color to {20303, 19018, 32639}
        set ANSI magenta color to {22873, 16191, 32382}
        set ANSI cyan color to {22359, 30326, 32639}
        set ANSI white color to {25700, 23901, 28527}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17990, 15420, 21331}
        set ANSI bright red color to {57311, 20560, 26214}
        set ANSI bright green color to {21074, 57568, 50372}
        set ANSI bright yellow color to {57568, 49858, 34438}
        set ANSI bright blue color to {36494, 34438, 57311}
        set ANSI bright magenta color to {42662, 30069, 57311}
        set ANSI bright cyan color to {39578, 54227, 57311}
        set ANSI bright white color to {35980, 37265, 64250}
    end tell
end tell
