(*
    base24 Purple Rain
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 2056, 19018}
        set foreground color to {54227, 54484, 54484}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 9766, 3341}
        set ANSI green color to {39578, 58082, 1028}
        set ANSI yellow color to {0, 42405, 65535}
        set ANSI blue color to {0, 41377, 63993}
        set ANSI magenta color to {32896, 23387, 46517}
        set ANSI cyan color to {0, 56797, 61423}
        set ANSI white color to {65278, 65535, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {65535, 16962, 20560}
        set ANSI bright green color to {47288, 58339, 28013}
        set ANSI bright yellow color to {65535, 55512, 21074}
        set ANSI bright blue color to {0, 42405, 65535}
        set ANSI bright magenta color to {43947, 31354, 61423}
        set ANSI bright cyan color to {29812, 64764, 62451}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
