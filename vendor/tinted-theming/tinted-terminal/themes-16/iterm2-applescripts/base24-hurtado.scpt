(*
    base24 Hurtado
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {22359, 22359, 22359}
        set ANSI red color to {65535, 6939, 0}
        set ANSI green color to {42405, 57311, 21845}
        set ANSI yellow color to {35209, 48573, 65535}
        set ANSI blue color to {18504, 25443, 34695}
        set ANSI magenta color to {64764, 24158, 61680}
        set ANSI cyan color to {34181, 59881, 65278}
        set ANSI white color to {52171, 52171, 52171}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {9509, 9509, 9509}
        set ANSI bright red color to {54484, 7196, 0}
        set ANSI bright green color to {42405, 57311, 21845}
        set ANSI bright yellow color to {64507, 59367, 18761}
        set ANSI bright blue color to {35209, 48573, 65535}
        set ANSI bright magenta color to {49087, 0, 49344}
        set ANSI bright cyan color to {34181, 59881, 65278}
        set ANSI bright white color to {56283, 56283, 56283}
    end tell
end tell
