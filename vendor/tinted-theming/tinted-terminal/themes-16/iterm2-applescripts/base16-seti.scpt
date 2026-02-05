(*
    base16 Seti UI
    Scheme author: 
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5397, 5911, 6168}
        set foreground color to {54998, 54998, 54998}

        -- Set ANSI Colors
        set ANSI black color to {5397, 5911, 6168}
        set ANSI red color to {52685, 16191, 17733}
        set ANSI green color to {40863, 51914, 22102}
        set ANSI yellow color to {59110, 52685, 26985}
        set ANSI blue color to {21845, 46517, 56283}
        set ANSI magenta color to {41120, 29812, 50372}
        set ANSI cyan color to {21845, 56283, 48830}
        set ANSI white color to {54998, 54998, 54998}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16705, 21331, 23387}
        set ANSI bright red color to {52685, 16191, 17733}
        set ANSI bright green color to {40863, 51914, 22102}
        set ANSI bright yellow color to {59110, 52685, 26985}
        set ANSI bright blue color to {21845, 46517, 56283}
        set ANSI bright magenta color to {41120, 29812, 50372}
        set ANSI bright cyan color to {21845, 56283, 48830}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
