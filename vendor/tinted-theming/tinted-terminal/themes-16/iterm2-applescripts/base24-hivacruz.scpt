(*
    base24 Hivacruz
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4883, 9509, 14135}
        set foreground color to {35980, 37522, 44204}

        -- Set ANSI Colors
        set ANSI black color to {4883, 9509, 14135}
        set ANSI red color to {51657, 18761, 8738}
        set ANSI green color to {44204, 38807, 14649}
        set ANSI yellow color to {35209, 36494, 42148}
        set ANSI blue color to {15677, 36751, 53713}
        set ANSI magenta color to {26214, 31097, 52428}
        set ANSI cyan color to {8738, 41634, 51657}
        set ANSI white color to {35980, 37522, 44204}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30326, 32125, 40092}
        set ANSI bright red color to {51143, 27499, 10537}
        set ANSI bright green color to {29555, 44461, 17219}
        set ANSI bright yellow color to {24158, 26214, 34695}
        set ANSI bright blue color to {35209, 36494, 42148}
        set ANSI bright magenta color to {57311, 58082, 61937}
        set ANSI bright cyan color to {40092, 25443, 31354}
        set ANSI bright white color to {62965, 63479, 65535}
    end tell
end tell
