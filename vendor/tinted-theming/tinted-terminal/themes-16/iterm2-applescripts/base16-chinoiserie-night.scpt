(*
    base16 Chinoiserie Night
    Scheme author: Di Wang (https://cs.cmu.edu/~diw3)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 7453, 7453}
        set foreground color to {50372, 52171, 53199}

        -- Set ANSI Colors
        set ANSI black color to {7453, 7453, 7453}
        set ANSI red color to {61680, 31868, 33410}
        set ANSI green color to {45746, 53199, 34695}
        set ANSI yellow color to {62708, 52942, 26985}
        set ANSI blue color to {36751, 45746, 51657}
        set ANSI magenta color to {48830, 40349, 47545}
        set ANSI cyan color to {45232, 54741, 57311}
        set ANSI white color to {50372, 52171, 53199}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {37265, 32896, 29298}
        set ANSI bright red color to {61680, 31868, 33410}
        set ANSI bright green color to {45746, 53199, 34695}
        set ANSI bright yellow color to {62708, 52942, 26985}
        set ANSI bright blue color to {36751, 45746, 51657}
        set ANSI bright magenta color to {48830, 40349, 47545}
        set ANSI bright cyan color to {45232, 54741, 57311}
        set ANSI bright white color to {65535, 65278, 63993}
    end tell
end tell
