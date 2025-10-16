(*
    base16 Atelier Estuary Light
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62708, 62451, 60652}
        set foreground color to {24415, 24158, 20046}

        -- Set ANSI Colors
        set ANSI black color to {59367, 59110, 57311}
        set ANSI red color to {47802, 25186, 13878}
        set ANSI green color to {32125, 38807, 9766}
        set ANSI yellow color to {42405, 39064, 3341}
        set ANSI blue color to {13878, 41377, 26214}
        set ANSI magenta color to {24415, 37265, 33410}
        set ANSI cyan color to {23387, 40349, 18504}
        set ANSI white color to {12336, 12079, 10023}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {37522, 37265, 33153}
        set ANSI bright red color to {47802, 25186, 13878}
        set ANSI bright green color to {32125, 38807, 9766}
        set ANSI bright yellow color to {42405, 39064, 3341}
        set ANSI bright blue color to {13878, 41377, 26214}
        set ANSI bright magenta color to {24415, 37265, 33410}
        set ANSI bright cyan color to {23387, 40349, 18504}
        set ANSI bright white color to {8738, 8738, 6939}
    end tell
end tell
