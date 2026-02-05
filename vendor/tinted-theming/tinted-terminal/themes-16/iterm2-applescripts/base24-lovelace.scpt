(*
    base24 Lovelace
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 7967, 10280}
        set foreground color to {52942, 52942, 54227}

        -- Set ANSI Colors
        set ANSI black color to {7453, 7967, 10280}
        set ANSI red color to {62451, 32639, 38807}
        set ANSI green color to {23130, 57054, 52685}
        set ANSI yellow color to {21845, 28527, 65535}
        set ANSI blue color to {34952, 38807, 62708}
        set ANSI magenta color to {50629, 29812, 56797}
        set ANSI cyan color to {31097, 59110, 62451}
        set ANSI white color to {52942, 52942, 54227}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28784, 29298, 33153}
        set ANSI bright red color to {65535, 18761, 29041}
        set ANSI bright green color to {6168, 58339, 51400}
        set ANSI bright yellow color to {65535, 32896, 14135}
        set ANSI bright blue color to {21845, 28527, 65535}
        set ANSI bright magenta color to {45232, 17219, 53713}
        set ANSI bright cyan color to {16191, 56540, 61166}
        set ANSI bright white color to {48830, 48830, 49601}
    end tell
end tell
