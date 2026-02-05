(*
    base16 Harmonic16 Light
    Scheme author: Jannik Siebert (https://github.com/janniks)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63479, 63993, 64507}
        set foreground color to {16448, 23644, 31097}

        -- Set ANSI Colors
        set ANSI black color to {63479, 63993, 64507}
        set ANSI red color to {49087, 35723, 22102}
        set ANSI green color to {22102, 49087, 35723}
        set ANSI yellow color to {35723, 49087, 22102}
        set ANSI blue color to {35723, 22102, 49087}
        set ANSI magenta color to {49087, 22102, 35723}
        set ANSI cyan color to {22102, 35723, 49087}
        set ANSI white color to {16448, 23644, 31097}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {43690, 48316, 52942}
        set ANSI bright red color to {49087, 35723, 22102}
        set ANSI bright green color to {22102, 49087, 35723}
        set ANSI bright yellow color to {35723, 49087, 22102}
        set ANSI bright blue color to {35723, 22102, 49087}
        set ANSI bright magenta color to {49087, 22102, 35723}
        set ANSI bright cyan color to {22102, 35723, 49087}
        set ANSI bright white color to {2827, 7196, 11308}
    end tell
end tell
