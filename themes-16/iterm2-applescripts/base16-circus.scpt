(*
    base16 Circus
    Scheme author: Stephan Boyer (https://github.com/stepchowfun) and Esther Wang (https://github.com/ewang12)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 6425, 6425}
        set foreground color to {42919, 42919, 42919}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8224, 8224}
        set ANSI red color to {56540, 25957, 32125}
        set ANSI green color to {33924, 47545, 31868}
        set ANSI yellow color to {50115, 47802, 25443}
        set ANSI blue color to {25443, 40606, 58596}
        set ANSI magenta color to {47288, 34952, 58082}
        set ANSI cyan color to {19275, 45489, 42919}
        set ANSI white color to {32896, 32896, 32896}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12336, 12336, 12336}
        set ANSI bright red color to {56540, 25957, 32125}
        set ANSI bright green color to {33924, 47545, 31868}
        set ANSI bright yellow color to {50115, 47802, 25443}
        set ANSI bright blue color to {25443, 40606, 58596}
        set ANSI bright magenta color to {47288, 34952, 58082}
        set ANSI bright cyan color to {19275, 45489, 42919}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
