(*
    base16 Materia
    Scheme author: Defman21
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 12850, 14392}
        set foreground color to {52685, 54227, 57054}

        -- Set ANSI Colors
        set ANSI black color to {9766, 12850, 14392}
        set ANSI red color to {60652, 24415, 26471}
        set ANSI green color to {35723, 54998, 18761}
        set ANSI yellow color to {65535, 52428, 0}
        set ANSI blue color to {35209, 56797, 65535}
        set ANSI magenta color to {33410, 43690, 65535}
        set ANSI cyan color to {32896, 52171, 50372}
        set ANSI white color to {52685, 54227, 57054}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28784, 30840, 32896}
        set ANSI bright red color to {60652, 24415, 26471}
        set ANSI bright green color to {35723, 54998, 18761}
        set ANSI bright yellow color to {65535, 52428, 0}
        set ANSI bright blue color to {35209, 56797, 65535}
        set ANSI bright magenta color to {33410, 43690, 65535}
        set ANSI bright cyan color to {32896, 52171, 50372}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
