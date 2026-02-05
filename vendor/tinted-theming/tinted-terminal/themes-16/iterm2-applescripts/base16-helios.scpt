(*
    base16 Helios
    Scheme author: Alex Meyer (https://github.com/reyemxela)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 8224, 8481}
        set foreground color to {54741, 54741, 54741}

        -- Set ANSI Colors
        set ANSI black color to {7453, 8224, 8481}
        set ANSI red color to {55255, 9766, 14392}
        set ANSI green color to {34952, 47545, 11565}
        set ANSI yellow color to {61937, 40349, 6682}
        set ANSI blue color to {7710, 35723, 44204}
        set ANSI magenta color to {48830, 16962, 25700}
        set ANSI cyan color to {6939, 42405, 38293}
        set ANSI white color to {54741, 54741, 54741}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28527, 30069, 31097}
        set ANSI bright red color to {55255, 9766, 14392}
        set ANSI bright green color to {34952, 47545, 11565}
        set ANSI bright yellow color to {61937, 40349, 6682}
        set ANSI bright blue color to {7710, 35723, 44204}
        set ANSI bright magenta color to {48830, 16962, 25700}
        set ANSI bright cyan color to {6939, 42405, 38293}
        set ANSI bright white color to {58853, 58853, 58853}
    end tell
end tell
