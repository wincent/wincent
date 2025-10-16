(*
    base24 Misterioso
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11565, 14135, 17219}
        set foreground color to {48830, 48830, 48573}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 16962, 16962}
        set ANSI green color to {29812, 44975, 26728}
        set ANSI yellow color to {8995, 55255, 55255}
        set ANSI blue color to {13107, 36751, 34438}
        set ANSI magenta color to {38036, 4883, 58853}
        set ANSI cyan color to {8995, 55255, 55255}
        set ANSI white color to {57825, 57825, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {65535, 12850, 16962}
        set ANSI bright green color to {29812, 52685, 26728}
        set ANSI bright yellow color to {65535, 47545, 10537}
        set ANSI bright blue color to {8995, 55255, 55255}
        set ANSI bright magenta color to {65535, 14135, 65535}
        set ANSI bright cyan color to {0, 60909, 57825}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
