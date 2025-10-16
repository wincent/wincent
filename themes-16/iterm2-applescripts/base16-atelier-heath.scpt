(*
    base16 Atelier Heath
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 6168, 6939}
        set foreground color to {43947, 39835, 43947}

        -- Set ANSI Colors
        set ANSI black color to {10537, 8995, 10537}
        set ANSI red color to {51914, 16448, 11051}
        set ANSI green color to {37265, 35723, 15163}
        set ANSI yellow color to {48059, 35466, 13621}
        set ANSI blue color to {20817, 27242, 60652}
        set ANSI magenta color to {31611, 22873, 49344}
        set ANSI cyan color to {5397, 37779, 37779}
        set ANSI white color to {55512, 51914, 55512}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26985, 23901, 26985}
        set ANSI bright red color to {51914, 16448, 11051}
        set ANSI bright green color to {37265, 35723, 15163}
        set ANSI bright yellow color to {48059, 35466, 13621}
        set ANSI bright blue color to {20817, 27242, 60652}
        set ANSI bright magenta color to {31611, 22873, 49344}
        set ANSI bright cyan color to {5397, 37779, 37779}
        set ANSI bright white color to {63479, 62451, 63479}
    end tell
end tell
