(*
    base24 Vibrant Ink
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {52685, 52685, 52685}

        -- Set ANSI Colors
        set ANSI black color to {34695, 34695, 34695}
        set ANSI red color to {65535, 26214, 0}
        set ANSI green color to {52428, 65535, 1028}
        set ANSI yellow color to {0, 0, 65535}
        set ANSI blue color to {17476, 46003, 52428}
        set ANSI magenta color to {39321, 13107, 52428}
        set ANSI cyan color to {17476, 46003, 52428}
        set ANSI white color to {62965, 62965, 62965}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {65535, 0, 0}
        set ANSI bright green color to {0, 65535, 0}
        set ANSI bright yellow color to {65535, 65535, 0}
        set ANSI bright blue color to {0, 0, 65535}
        set ANSI bright magenta color to {65535, 0, 65535}
        set ANSI bright cyan color to {0, 65535, 65535}
        set ANSI bright white color to {58853, 58853, 58853}
    end tell
end tell
