(*
    base24 Galaxy
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 10280, 13878}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {63993, 21845, 24415}
        set ANSI green color to {8224, 44975, 35209}
        set ANSI yellow color to {22616, 40092, 62965}
        set ANSI blue color to {22616, 40092, 62965}
        set ANSI magenta color to {37779, 19789, 38293}
        set ANSI cyan color to {7710, 40606, 59110}
        set ANSI white color to {48059, 48059, 48059}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {64250, 35723, 36494}
        set ANSI bright green color to {13364, 48059, 39321}
        set ANSI bright yellow color to {65535, 65535, 21845}
        set ANSI bright blue color to {22616, 40092, 62965}
        set ANSI bright magenta color to {59367, 21845, 39064}
        set ANSI bright cyan color to {14649, 30840, 48059}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
