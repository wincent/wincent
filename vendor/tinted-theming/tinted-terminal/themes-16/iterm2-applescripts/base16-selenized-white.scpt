(*
    base16 selenized-white
    Scheme author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {18247, 18247, 18247}

        -- Set ANSI Colors
        set ANSI black color to {60395, 60395, 60395}
        set ANSI red color to {49087, 0, 0}
        set ANSI green color to {0, 33924, 0}
        set ANSI yellow color to {44975, 34181, 0}
        set ANSI blue color to {0, 21588, 53199}
        set ANSI magenta color to {27499, 16448, 50115}
        set ANSI cyan color to {0, 39578, 35466}
        set ANSI white color to {10280, 10280, 10280}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {52685, 52685, 52685}
        set ANSI bright red color to {49087, 0, 0}
        set ANSI bright green color to {0, 33924, 0}
        set ANSI bright yellow color to {44975, 34181, 0}
        set ANSI bright blue color to {0, 21588, 53199}
        set ANSI bright magenta color to {27499, 16448, 50115}
        set ANSI bright cyan color to {0, 39578, 35466}
        set ANSI bright white color to {10280, 10280, 10280}
    end tell
end tell
