(*
    base16 Atelier Seaside
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4883, 5397, 4883}
        set foreground color to {35980, 42662, 35980}

        -- Set ANSI Colors
        set ANSI black color to {4883, 5397, 4883}
        set ANSI red color to {59110, 6425, 15420}
        set ANSI green color to {10537, 41891, 10537}
        set ANSI yellow color to {39064, 39064, 6939}
        set ANSI blue color to {15677, 25186, 62965}
        set ANSI magenta color to {44461, 11051, 61166}
        set ANSI cyan color to {6425, 39321, 46003}
        set ANSI white color to {35980, 42662, 35980}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26728, 32125, 26728}
        set ANSI bright red color to {59110, 6425, 15420}
        set ANSI bright green color to {10537, 41891, 10537}
        set ANSI bright yellow color to {39064, 39064, 6939}
        set ANSI bright blue color to {15677, 25186, 62965}
        set ANSI bright magenta color to {44461, 11051, 61166}
        set ANSI bright cyan color to {6425, 39321, 46003}
        set ANSI bright white color to {62708, 64507, 62708}
    end tell
end tell
