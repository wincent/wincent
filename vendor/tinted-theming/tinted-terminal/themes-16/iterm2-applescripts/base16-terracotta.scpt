(*
    base16 Terracotta
    Scheme author: Alexander Rossell Hayes (https://github.com/rossellhayes)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61423, 60138, 59624}
        set foreground color to {18247, 14135, 12593}

        -- Set ANSI Colors
        set ANSI black color to {57311, 54998, 53713}
        set ANSI red color to {42919, 20560, 17733}
        set ANSI green color to {31354, 35209, 19018}
        set ANSI yellow color to {52942, 38036, 15934}
        set ANSI blue color to {25186, 21845, 29812}
        set ANSI magenta color to {36237, 22873, 26728}
        set ANSI cyan color to {33924, 32639, 40606}
        set ANSI white color to {13621, 10794, 9509}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {53456, 49601, 48059}
        set ANSI bright red color to {42919, 20560, 17733}
        set ANSI bright green color to {31354, 35209, 19018}
        set ANSI bright yellow color to {52942, 38036, 15934}
        set ANSI bright blue color to {25186, 21845, 29812}
        set ANSI bright magenta color to {36237, 22873, 26728}
        set ANSI bright cyan color to {33924, 32639, 40606}
        set ANSI bright white color to {9252, 7196, 6425}
    end tell
end tell
