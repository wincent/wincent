(*
    base24 Brogrammer
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4883, 4883, 4883}
        set foreground color to {49601, 51400, 55255}

        -- Set ANSI Colors
        set ANSI black color to {7967, 7967, 7967}
        set ANSI red color to {63479, 4369, 6168}
        set ANSI green color to {11308, 50629, 23901}
        set ANSI yellow color to {3855, 32896, 54741}
        set ANSI blue color to {10794, 33924, 53970}
        set ANSI magenta color to {20046, 22873, 47031}
        set ANSI cyan color to {3855, 32896, 54741}
        set ANSI white color to {58339, 59110, 60909}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {10794, 12593, 16705}
        set ANSI bright red color to {57054, 13364, 11822}
        set ANSI bright green color to {7453, 53970, 24672}
        set ANSI bright yellow color to {62194, 48573, 2313}
        set ANSI bright blue color to {20560, 39835, 56540}
        set ANSI bright magenta color to {21074, 20303, 47545}
        set ANSI bright cyan color to {10280, 39578, 61680}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
