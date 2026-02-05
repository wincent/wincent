(*
    base24 ENCOM
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {40863, 0, 0}
        set ANSI green color to {0, 35723, 0}
        set ANSI yellow color to {0, 0, 65535}
        set ANSI blue color to {0, 33153, 65535}
        set ANSI magenta color to {48316, 0, 51914}
        set ANSI cyan color to {0, 35723, 35723}
        set ANSI white color to {41377, 41377, 41377}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 28270, 28270}
        set ANSI bright red color to {65535, 0, 0}
        set ANSI bright green color to {0, 61166, 0}
        set ANSI bright yellow color to {65535, 65535, 0}
        set ANSI bright blue color to {0, 0, 65535}
        set ANSI bright magenta color to {65535, 0, 65535}
        set ANSI bright cyan color to {0, 52685, 52685}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
