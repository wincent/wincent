(*
    base16 Atelier Plateau Light
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62708, 60652, 60652}
        set foreground color to {22616, 20560, 20560}

        -- Set ANSI Colors
        set ANSI black color to {59367, 57311, 57311}
        set ANSI red color to {51914, 18761, 18761}
        set ANSI green color to {19275, 35723, 35723}
        set ANSI yellow color to {41120, 28270, 15163}
        set ANSI blue color to {29298, 29298, 51914}
        set ANSI magenta color to {33924, 25700, 50372}
        set ANSI cyan color to {21588, 34181, 46774}
        set ANSI white color to {10537, 9252, 9252}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {35466, 34181, 34181}
        set ANSI bright red color to {51914, 18761, 18761}
        set ANSI bright green color to {19275, 35723, 35723}
        set ANSI bright yellow color to {41120, 28270, 15163}
        set ANSI bright blue color to {29298, 29298, 51914}
        set ANSI bright magenta color to {33924, 25700, 50372}
        set ANSI bright cyan color to {21588, 34181, 46774}
        set ANSI bright white color to {6939, 6168, 6168}
    end tell
end tell
