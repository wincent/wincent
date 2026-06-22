(*
    base16 Papel
    Scheme author: Teshre
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62965, 61423, 58082}
        set foreground color to {14906, 11822, 8224}

        -- Set ANSI Colors
        set ANSI black color to {62965, 61423, 58082}
        set ANSI red color to {49344, 14649, 11051}
        set ANSI green color to {24158, 31354, 10280}
        set ANSI yellow color to {43176, 30326, 6682}
        set ANSI blue color to {11308, 27756, 41120}
        set ANSI magenta color to {39835, 19789, 36494}
        set ANSI cyan color to {10794, 35466, 31354}
        set ANSI white color to {14906, 11822, 8224}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {39578, 35980, 30326}
        set ANSI bright red color to {49344, 14649, 11051}
        set ANSI bright green color to {24158, 31354, 10280}
        set ANSI bright yellow color to {43176, 30326, 6682}
        set ANSI bright blue color to {11308, 27756, 41120}
        set ANSI bright magenta color to {39835, 19789, 36494}
        set ANSI bright cyan color to {10794, 35466, 31354}
        set ANSI bright white color to {61423, 59624, 55512}
    end tell
end tell
