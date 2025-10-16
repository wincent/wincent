(*
    base24 Twilight
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5140, 5140, 5140}
        set foreground color to {51400, 51400, 42919}

        -- Set ANSI Colors
        set ANSI black color to {5140, 5140, 5140}
        set ANSI red color to {49344, 27756, 17219}
        set ANSI green color to {44975, 47545, 31097}
        set ANSI yellow color to {23130, 23901, 24929}
        set ANSI blue color to {17476, 17990, 18761}
        set ANSI magenta color to {46260, 48830, 31611}
        set ANSI cyan color to {30583, 33410, 33924}
        set ANSI white color to {65278, 65535, 54227}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {9766, 9766, 9766}
        set ANSI bright red color to {56797, 31868, 19532}
        set ANSI bright green color to {52171, 55512, 35980}
        set ANSI bright yellow color to {57825, 50372, 32125}
        set ANSI bright blue color to {23130, 23901, 24929}
        set ANSI bright magenta color to {53456, 56283, 36494}
        set ANSI bright cyan color to {35466, 39064, 39578}
        set ANSI bright white color to {65278, 65535, 54227}
    end tell
end tell
