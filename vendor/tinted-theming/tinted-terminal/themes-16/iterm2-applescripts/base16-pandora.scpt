(*
    base16 pandora
    Scheme author: Cassandra Fox
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4883, 4626, 4883}
        set foreground color to {61937, 23644, 39321}

        -- Set ANSI Colors
        set ANSI black color to {12079, 6168, 8995}
        set ANSI red color to {45232, 2827, 26985}
        set ANSI green color to {40349, 57311, 26985}
        set ANSI yellow color to {65535, 52428, 0}
        set ANSI blue color to {0, 32896, 32896}
        set ANSI magenta color to {41634, 16448, 12336}
        set ANSI cyan color to {29041, 19532, 42662}
        set ANSI white color to {33153, 20560, 27242}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18247, 8738, 13364}
        set ANSI bright red color to {45232, 2827, 26985}
        set ANSI bright green color to {40349, 57311, 26985}
        set ANSI bright yellow color to {65535, 52428, 0}
        set ANSI bright blue color to {0, 32896, 32896}
        set ANSI bright magenta color to {41634, 16448, 12336}
        set ANSI bright cyan color to {29041, 19532, 42662}
        set ANSI bright white color to {25443, 8738, 10023}
    end tell
end tell
