(*
    base16 Atelier Cave
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 5911, 7196}
        set foreground color to {35723, 34695, 37522}

        -- Set ANSI Colors
        set ANSI black color to {9766, 8995, 10794}
        set ANSI red color to {48830, 17990, 30840}
        set ANSI green color to {10794, 37522, 37522}
        set ANSI yellow color to {41120, 28270, 15163}
        set ANSI blue color to {22359, 28013, 56283}
        set ANSI magenta color to {38293, 23130, 59367}
        set ANSI cyan color to {14649, 35723, 50886}
        set ANSI white color to {58082, 57311, 59367}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22616, 21074, 24672}
        set ANSI bright red color to {48830, 17990, 30840}
        set ANSI bright green color to {10794, 37522, 37522}
        set ANSI bright yellow color to {41120, 28270, 15163}
        set ANSI bright blue color to {22359, 28013, 56283}
        set ANSI bright magenta color to {38293, 23130, 59367}
        set ANSI bright cyan color to {14649, 35723, 50886}
        set ANSI bright white color to {61423, 60652, 62708}
    end tell
end tell
