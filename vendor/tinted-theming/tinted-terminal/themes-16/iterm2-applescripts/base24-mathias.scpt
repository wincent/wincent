(*
    base24 Mathias
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {51914, 51914, 51914}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {58853, 8738, 8738}
        set ANSI green color to {42662, 58339, 11565}
        set ANSI yellow color to {21845, 21845, 65535}
        set ANSI blue color to {50372, 36237, 65535}
        set ANSI magenta color to {64250, 9509, 29555}
        set ANSI cyan color to {26471, 55769, 61680}
        set ANSI white color to {51914, 51914, 51914}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31868, 31868, 31868}
        set ANSI bright red color to {65535, 21845, 21845}
        set ANSI bright green color to {21845, 65535, 21845}
        set ANSI bright yellow color to {65535, 65535, 21845}
        set ANSI bright blue color to {21845, 21845, 65535}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {21845, 65535, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
