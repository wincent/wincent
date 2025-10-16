(*
    base16 Cupertino
    Scheme author: Defman21
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {16448, 16448, 16448}

        -- Set ANSI Colors
        set ANSI black color to {49344, 49344, 49344}
        set ANSI red color to {50372, 6682, 5397}
        set ANSI green color to {0, 29812, 0}
        set ANSI yellow color to {33410, 27499, 10280}
        set ANSI blue color to {0, 0, 65535}
        set ANSI magenta color to {43433, 3341, 37265}
        set ANSI cyan color to {12593, 33924, 38293}
        set ANSI white color to {16448, 16448, 16448}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {49344, 49344, 49344}
        set ANSI bright red color to {50372, 6682, 5397}
        set ANSI bright green color to {0, 29812, 0}
        set ANSI bright yellow color to {33410, 27499, 10280}
        set ANSI bright blue color to {0, 0, 65535}
        set ANSI bright magenta color to {43433, 3341, 37265}
        set ANSI bright cyan color to {12593, 33924, 38293}
        set ANSI bright white color to {24158, 24158, 24158}
    end tell
end tell
