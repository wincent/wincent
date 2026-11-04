(*
    base24 Lumina Dusk Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63222, 62451, 65278}
        set foreground color to {11822, 10537, 17733}

        -- Set ANSI Colors
        set ANSI black color to {63222, 62451, 65278}
        set ANSI red color to {34695, 9252, 8995}
        set ANSI green color to {13621, 30069, 17733}
        set ANSI yellow color to {40606, 24929, 6939}
        set ANSI blue color to {12593, 25443, 44461}
        set ANSI magenta color to {31611, 17990, 42148}
        set ANSI cyan color to {0, 29041, 34181}
        set ANSI white color to {11822, 10537, 17733}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {54484, 53456, 57054}
        set ANSI bright red color to {25186, 8995, 8224}
        set ANSI bright green color to {8481, 24672, 13107}
        set ANSI bright yellow color to {34181, 20046, 1799}
        set ANSI bright blue color to {11051, 20560, 34952}
        set ANSI bright magenta color to {29041, 14906, 27756}
        set ANSI bright cyan color to {0, 23387, 27756}
        set ANSI bright white color to {11822, 10537, 17733}
    end tell
end tell
