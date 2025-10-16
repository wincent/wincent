(*
    base24 Sea Shells
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2056, 4883, 6682}
        set foreground color to {47031, 40092, 32382}

        -- Set ANSI Colors
        set ANSI black color to {5911, 14392, 19532}
        set ANSI red color to {53713, 20560, 8995}
        set ANSI green color to {514, 31868, 39835}
        set ANSI yellow color to {6939, 48316, 56797}
        set ANSI blue color to {7710, 18761, 20560}
        set ANSI magenta color to {26728, 54227, 61937}
        set ANSI cyan color to {20560, 41891, 46517}
        set ANSI white color to {57054, 47288, 36237}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16962, 19275, 21074}
        set ANSI bright red color to {54227, 34438, 30583}
        set ANSI bright green color to {24929, 35980, 39064}
        set ANSI bright yellow color to {65021, 53970, 40606}
        set ANSI bright blue color to {6939, 48316, 56797}
        set ANSI bright magenta color to {48059, 58339, 61166}
        set ANSI bright cyan color to {34438, 43947, 46003}
        set ANSI bright white color to {65278, 58339, 52685}
    end tell
end tell
