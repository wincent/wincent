(*
    base24 Grape
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 5140, 8995}
        set foreground color to {35980, 35466, 37522}

        -- Set ANSI Colors
        set ANSI black color to {11565, 10280, 15934}
        set ANSI red color to {60652, 8481, 24672}
        set ANSI green color to {7967, 43433, 6939}
        set ANSI yellow color to {43433, 48059, 60395}
        set ANSI blue color to {18504, 31868, 62708}
        set ANSI magenta color to {35980, 13621, 51400}
        set ANSI cyan color to {14906, 56797, 60909}
        set ANSI white color to {40606, 40606, 41120}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22616, 20560, 27242}
        set ANSI bright red color to {61680, 29041, 39578}
        set ANSI bright green color to {21074, 43433, 23901}
        set ANSI bright yellow color to {45746, 56540, 34695}
        set ANSI bright blue color to {43433, 48059, 60395}
        set ANSI bright magenta color to {44204, 33153, 49601}
        set ANSI bright cyan color to {40092, 58339, 60138}
        set ANSI bright white color to {41377, 34952, 63479}
    end tell
end tell
