(*
    base24 Builtin Tango Dark
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {46003, 47031, 45232}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {52428, 0, 0}
        set ANSI green color to {20046, 39578, 1285}
        set ANSI yellow color to {29041, 40606, 53199}
        set ANSI blue color to {13364, 25700, 42148}
        set ANSI magenta color to {29812, 20560, 31354}
        set ANSI cyan color to {1285, 39064, 39578}
        set ANSI white color to {46003, 47031, 45232}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29555, 30583, 29298}
        set ANSI bright red color to {61423, 10280, 10280}
        set ANSI bright green color to {35466, 58082, 13364}
        set ANSI bright yellow color to {64764, 59881, 20046}
        set ANSI bright blue color to {29041, 40606, 53199}
        set ANSI bright magenta color to {44461, 32382, 42919}
        set ANSI bright cyan color to {13364, 58082, 58082}
        set ANSI bright white color to {60909, 60909, 60652}
    end tell
end tell
