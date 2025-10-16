(*
    base24 Flat
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2056, 10280, 17733}
        set foreground color to {35980, 37779, 39578}

        -- Set ANSI Colors
        set ANSI black color to {7453, 10280, 17733}
        set ANSI red color to {43176, 8995, 8224}
        set ANSI green color to {11565, 38036, 16448}
        set ANSI yellow color to {15420, 32125, 53970}
        set ANSI blue color to {12593, 26471, 44204}
        set ANSI magenta color to {30840, 6682, 41120}
        set ANSI cyan color to {11308, 37779, 28784}
        set ANSI white color to {45232, 46774, 47802}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {11822, 11822, 17733}
        set ANSI bright red color to {54484, 12593, 11822}
        set ANSI bright green color to {12850, 42405, 18504}
        set ANSI bright yellow color to {58853, 48830, 3084}
        set ANSI bright blue color to {15420, 32125, 53970}
        set ANSI bright magenta color to {33410, 12336, 42919}
        set ANSI bright cyan color to {13621, 46003, 34695}
        set ANSI bright white color to {59367, 60652, 60909}
    end tell
end tell
