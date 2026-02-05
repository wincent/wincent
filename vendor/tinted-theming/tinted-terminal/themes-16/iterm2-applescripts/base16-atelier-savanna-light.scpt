(*
    base16 Atelier Savanna Light
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {60652, 62708, 61166}
        set foreground color to {21074, 24672, 22359}

        -- Set ANSI Colors
        set ANSI black color to {60652, 62708, 61166}
        set ANSI red color to {45489, 24929, 14649}
        set ANSI green color to {18504, 39321, 25443}
        set ANSI yellow color to {41120, 32382, 15163}
        set ANSI blue color to {18247, 35980, 37008}
        set ANSI magenta color to {21845, 34181, 39835}
        set ANSI cyan color to {7196, 39578, 41120}
        set ANSI white color to {21074, 24672, 22359}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30840, 34695, 32125}
        set ANSI bright red color to {45489, 24929, 14649}
        set ANSI bright green color to {18504, 39321, 25443}
        set ANSI bright yellow color to {41120, 32382, 15163}
        set ANSI bright blue color to {18247, 35980, 37008}
        set ANSI bright magenta color to {21845, 34181, 39835}
        set ANSI bright cyan color to {7196, 39578, 41120}
        set ANSI bright white color to {5911, 7196, 6425}
    end tell
end tell
