(*
    base16 Arroz con Dulce
    Scheme author: Richard Martinez
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 63736, 59367}
        set foreground color to {19018, 11308, 8224}

        -- Set ANSI Colors
        set ANSI black color to {65535, 63736, 59367}
        set ANSI red color to {41377, 7453, 18504}
        set ANSI green color to {41634, 14392, 3084}
        set ANSI yellow color to {34181, 21845, 0}
        set ANSI blue color to {22873, 16448, 41120}
        set ANSI magenta color to {35980, 7967, 26728}
        set ANSI cyan color to {39064, 9766, 15934}
        set ANSI white color to {19018, 11308, 8224}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {51400, 42919, 31354}
        set ANSI bright red color to {41377, 7453, 18504}
        set ANSI bright green color to {41634, 14392, 3084}
        set ANSI bright yellow color to {34181, 21845, 0}
        set ANSI bright blue color to {22873, 16448, 41120}
        set ANSI bright magenta color to {35980, 7967, 26728}
        set ANSI bright cyan color to {39064, 9766, 15934}
        set ANSI bright white color to {8481, 4369, 2827}
    end tell
end tell
