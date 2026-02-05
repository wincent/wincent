(*
    base16 Atelier Forest Light
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61937, 61423, 61166}
        set foreground color to {26728, 24929, 24158}

        -- Set ANSI Colors
        set ANSI black color to {61937, 61423, 61166}
        set ANSI red color to {62194, 11308, 16448}
        set ANSI green color to {31611, 38807, 9766}
        set ANSI yellow color to {50115, 33924, 6168}
        set ANSI blue color to {16448, 32382, 59367}
        set ANSI magenta color to {26214, 26214, 60138}
        set ANSI cyan color to {15677, 38807, 47288}
        set ANSI white color to {26728, 24929, 24158}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {40092, 38036, 37265}
        set ANSI bright red color to {62194, 11308, 16448}
        set ANSI bright green color to {31611, 38807, 9766}
        set ANSI bright yellow color to {50115, 33924, 6168}
        set ANSI bright blue color to {16448, 32382, 59367}
        set ANSI bright magenta color to {26214, 26214, 60138}
        set ANSI bright cyan color to {15677, 38807, 47288}
        set ANSI bright white color to {6939, 6425, 6168}
    end tell
end tell
