(*
    base24 Toy Chest
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8995, 13878, 19018}
        set foreground color to {10023, 46774, 33924}

        -- Set ANSI Colors
        set ANSI black color to {11308, 16191, 22359}
        set ANSI red color to {48830, 11565, 9766}
        set ANSI green color to {6425, 37265, 29041}
        set ANSI yellow color to {13107, 42405, 55769}
        set ANSI blue color to {12850, 23901, 38550}
        set ANSI magenta color to {35466, 23901, 56283}
        set ANSI cyan color to {13621, 41120, 36751}
        set ANSI white color to {8995, 53456, 33410}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12850, 26728, 35209}
        set ANSI bright red color to {56797, 22873, 17219}
        set ANSI bright green color to {12336, 53199, 31611}
        set ANSI bright yellow color to {59367, 55255, 19275}
        set ANSI bright blue color to {13107, 42405, 55769}
        set ANSI bright magenta color to {44461, 27499, 56540}
        set ANSI bright cyan color to {16705, 50115, 44461}
        set ANSI bright white color to {54484, 54484, 54484}
    end tell
end tell
