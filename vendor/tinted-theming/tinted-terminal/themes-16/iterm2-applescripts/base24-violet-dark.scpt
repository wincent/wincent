(*
    base24 Violet Dark
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 7453, 7967}
        set foreground color to {42919, 42405, 40863}

        -- Set ANSI Colors
        set ANSI black color to {6939, 7453, 7967}
        set ANSI red color to {51657, 19532, 8738}
        set ANSI green color to {34181, 39064, 7196}
        set ANSI yellow color to {8224, 30069, 51143}
        set ANSI blue color to {11822, 35723, 52942}
        set ANSI magenta color to {53713, 14906, 33410}
        set ANSI cyan color to {12850, 41377, 39064}
        set ANSI white color to {42919, 42405, 40863}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25957, 26471, 26471}
        set ANSI bright red color to {48573, 13878, 4626}
        set ANSI bright green color to {29298, 35209, 771}
        set ANSI bright yellow color to {42405, 30583, 1028}
        set ANSI bright blue color to {8224, 30069, 51143}
        set ANSI bright magenta color to {50886, 6939, 28270}
        set ANSI bright cyan color to {9509, 37265, 34181}
        set ANSI bright white color to {51400, 50629, 48573}
    end tell
end tell
