(*
    base16 Swamp Light
    Scheme author: Masroof Maindak (https://github.com/masroof-maindak)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61937, 58339, 53713}
        set foreground color to {25700, 20817, 15934}

        -- Set ANSI Colors
        set ANSI black color to {61937, 58339, 53713}
        set ANSI red color to {53456, 38807, 0}
        set ANSI green color to {37008, 36237, 27242}
        set ANSI yellow color to {39321, 13107, 13107}
        set ANSI blue color to {49087, 31097, 31097}
        set ANSI magenta color to {40606, 21845, 33153}
        set ANSI cyan color to {53456, 38807, 0}
        set ANSI white color to {25700, 20817, 15934}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {46517, 42148, 37522}
        set ANSI bright red color to {53456, 38807, 0}
        set ANSI bright green color to {37008, 36237, 27242}
        set ANSI bright yellow color to {39321, 13107, 13107}
        set ANSI bright blue color to {49087, 31097, 31097}
        set ANSI bright magenta color to {40606, 21845, 33153}
        set ANSI bright cyan color to {53456, 38807, 0}
        set ANSI bright white color to {35980, 31611, 26728}
    end tell
end tell
