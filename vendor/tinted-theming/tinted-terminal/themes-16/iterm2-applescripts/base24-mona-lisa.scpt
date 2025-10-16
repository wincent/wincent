(*
    base24 Mona Lisa
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4369, 2827, 3341}
        set foreground color to {56026, 45489, 20046}

        -- Set ANSI Colors
        set ANSI black color to {13364, 6682, 3341}
        set ANSI red color to {39835, 10280, 6939}
        set ANSI green color to {25186, 24929, 12850}
        set ANSI yellow color to {40606, 45746, 46003}
        set ANSI blue color to {20817, 23387, 23644}
        set ANSI magenta color to {39835, 7453, 10537}
        set ANSI cyan color to {22616, 32896, 22102}
        set ANSI white color to {63222, 55255, 23644}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {34695, 16962, 10023}
        set ANSI bright red color to {65535, 16962, 12336}
        set ANSI bright green color to {46003, 45489, 25443}
        set ANSI bright yellow color to {65535, 38293, 25957}
        set ANSI bright blue color to {40606, 45746, 46003}
        set ANSI bright magenta color to {65535, 23387, 27242}
        set ANSI bright cyan color to {35209, 52428, 36494}
        set ANSI bright white color to {65535, 58853, 38807}
    end tell
end tell
