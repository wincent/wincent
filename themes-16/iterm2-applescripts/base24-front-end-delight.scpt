(*
    base24 Front End Delight
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 6939, 7453}
        set foreground color to {39064, 44204, 40092}

        -- Set ANSI Colors
        set ANSI black color to {9252, 9252, 9766}
        set ANSI red color to {63736, 20560, 6682}
        set ANSI green color to {22102, 22359, 17990}
        set ANSI yellow color to {13107, 37779, 51657}
        set ANSI blue color to {11308, 28784, 47031}
        set ANSI magenta color to {61680, 11565, 20046}
        set ANSI cyan color to {15163, 41120, 42405}
        set ANSI white color to {44204, 44204, 44204}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24158, 44204, 27756}
        set ANSI bright red color to {63222, 17219, 6425}
        set ANSI bright green color to {29812, 60395, 19532}
        set ANSI bright yellow color to {64764, 49858, 9252}
        set ANSI bright blue color to {13107, 37779, 51657}
        set ANSI bright magenta color to {59367, 24158, 20046}
        set ANSI bright cyan color to {20046, 48316, 58853}
        set ANSI bright white color to {35723, 29555, 23130}
    end tell
end tell
