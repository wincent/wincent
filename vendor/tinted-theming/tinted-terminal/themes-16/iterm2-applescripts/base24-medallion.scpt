(*
    base24 Medallion
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 6168, 2056}
        set foreground color to {44718, 42405, 30840}

        -- Set ANSI Colors
        set ANSI black color to {7453, 6168, 2056}
        set ANSI red color to {46517, 19532, 0}
        set ANSI green color to {31868, 35466, 5654}
        set ANSI yellow color to {43947, 47288, 65535}
        set ANSI blue color to {24672, 27499, 44975}
        set ANSI magenta color to {35723, 22873, 37008}
        set ANSI cyan color to {37008, 27499, 9509}
        set ANSI white color to {44718, 42405, 30840}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30840, 28013, 14392}
        set ANSI bright red color to {65535, 37265, 18504}
        set ANSI bright green color to {45489, 51657, 14906}
        set ANSI bright yellow color to {65535, 58596, 18761}
        set ANSI bright blue color to {43947, 47288, 65535}
        set ANSI bright magenta color to {65278, 40863, 65535}
        set ANSI bright cyan color to {65535, 48059, 20817}
        set ANSI bright white color to {65278, 54741, 38807}
    end tell
end tell
