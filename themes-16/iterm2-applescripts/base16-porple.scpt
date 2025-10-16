(*
    base16 Porple
    Scheme author: Niek den Breeje (https://github.com/AuditeMarlow)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10537, 11308, 13878}
        set foreground color to {55512, 55512, 55512}

        -- Set ANSI Colors
        set ANSI black color to {13107, 13107, 17476}
        set ANSI red color to {63736, 17733, 18247}
        set ANSI green color to {38293, 51143, 28527}
        set ANSI yellow color to {61423, 41377, 27499}
        set ANSI blue color to {33924, 34181, 52942}
        set ANSI magenta color to {47031, 18761, 35209}
        set ANSI cyan color to {25700, 34695, 36751}
        set ANSI white color to {59624, 59624, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18247, 16705, 24672}
        set ANSI bright red color to {63736, 17733, 18247}
        set ANSI bright green color to {38293, 51143, 28527}
        set ANSI bright yellow color to {61423, 41377, 27499}
        set ANSI bright blue color to {33924, 34181, 52942}
        set ANSI bright magenta color to {47031, 18761, 35209}
        set ANSI bright cyan color to {25700, 34695, 36751}
        set ANSI bright white color to {63736, 63736, 63736}
    end tell
end tell
