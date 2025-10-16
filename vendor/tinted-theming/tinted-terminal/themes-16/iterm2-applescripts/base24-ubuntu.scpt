(*
    base24 Ubuntu
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {12336, 2570, 9252}
        set foreground color to {46003, 47031, 45232}

        -- Set ANSI Colors
        set ANSI black color to {11822, 13364, 13878}
        set ANSI red color to {52428, 0, 0}
        set ANSI green color to {20046, 39578, 1542}
        set ANSI yellow color to {29298, 40863, 53199}
        set ANSI blue color to {13364, 25957, 42148}
        set ANSI magenta color to {30069, 20560, 31611}
        set ANSI cyan color to {1542, 39064, 39578}
        set ANSI white color to {54227, 55255, 53199}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 22359, 21331}
        set ANSI bright red color to {61423, 10537, 10537}
        set ANSI bright green color to {35466, 58082, 13364}
        set ANSI bright yellow color to {64764, 59881, 20303}
        set ANSI bright blue color to {29298, 40863, 53199}
        set ANSI bright magenta color to {44461, 32639, 43176}
        set ANSI bright cyan color to {13364, 58082, 58082}
        set ANSI bright white color to {61166, 61166, 60652}
    end tell
end tell
