(*
    base24 Ayu Light
    Scheme author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63736, 63993, 64250}
        set foreground color to {23644, 24929, 26214}

        -- Set ANSI Colors
        set ANSI black color to {63736, 63993, 64250}
        set ANSI red color to {61680, 29041, 29041}
        set ANSI green color to {27756, 49087, 18761}
        set ANSI yellow color to {62194, 44718, 18761}
        set ANSI blue color to {14649, 40606, 59110}
        set ANSI magenta color to {41891, 31354, 52428}
        set ANSI cyan color to {19532, 49087, 39321}
        set ANSI white color to {23644, 24929, 26214}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {41120, 42662, 44204}
        set ANSI bright red color to {65535, 29555, 33667}
        set ANSI bright green color to {34438, 46003, 0}
        set ANSI bright yellow color to {65535, 43690, 13107}
        set ANSI bright blue color to {18247, 35466, 52428}
        set ANSI bright magenta color to {46517, 38293, 54998}
        set ANSI bright cyan color to {21845, 46260, 54484}
        set ANSI bright white color to {16448, 17476, 18247}
    end tell
end tell
