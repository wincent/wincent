(*
    base24 Wryan
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 4112, 4112}
        set foreground color to {30326, 33924, 34952}

        -- Set ANSI Colors
        set ANSI black color to {13107, 13107, 13107}
        set ANSI red color to {35980, 17990, 25957}
        set ANSI green color to {10280, 29555, 29555}
        set ANSI yellow color to {18247, 31354, 46003}
        set ANSI blue color to {14649, 21845, 29555}
        set ANSI magenta color to {24158, 17990, 35980}
        set ANSI cyan color to {12593, 25957, 35980}
        set ANSI white color to {35209, 40092, 41377}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15677, 15677, 15677}
        set ANSI bright red color to {49087, 19789, 32896}
        set ANSI bright green color to {21331, 42662, 42662}
        set ANSI bright yellow color to {40606, 40606, 52171}
        set ANSI bright blue color to {18247, 31354, 46003}
        set ANSI bright magenta color to {32382, 25186, 46003}
        set ANSI bright cyan color to {24672, 38550, 49087}
        set ANSI bright white color to {49344, 49344, 49344}
    end tell
end tell
