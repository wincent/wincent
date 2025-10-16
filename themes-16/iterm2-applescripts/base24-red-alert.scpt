(*
    base24 Red Alert
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {30326, 9252, 8995}
        set foreground color to {43690, 43690, 43690}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {54741, 11822, 19789}
        set ANSI green color to {29041, 48830, 27499}
        set ANSI yellow color to {25957, 43433, 61680}
        set ANSI blue color to {18247, 39835, 60909}
        set ANSI magenta color to {59624, 30840, 54998}
        set ANSI cyan color to {27499, 48830, 47288}
        set ANSI white color to {54998, 54998, 54998}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {9766, 9766, 9766}
        set ANSI bright red color to {57568, 9252, 21331}
        set ANSI bright green color to {44975, 61680, 35723}
        set ANSI bright yellow color to {57311, 56797, 47031}
        set ANSI bright blue color to {25957, 43433, 61680}
        set ANSI bright magenta color to {56797, 47031, 57311}
        set ANSI bright cyan color to {47031, 57311, 56797}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
