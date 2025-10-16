(*
    base16 Isotope
    Scheme author: Jan T. Sott
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {16448, 16448, 16448}
        set ANSI red color to {65535, 0, 0}
        set ANSI green color to {13107, 65535, 0}
        set ANSI yellow color to {65535, 0, 39321}
        set ANSI blue color to {0, 26214, 65535}
        set ANSI magenta color to {52428, 0, 65535}
        set ANSI cyan color to {0, 65535, 65535}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24672, 24672, 24672}
        set ANSI bright red color to {65535, 0, 0}
        set ANSI bright green color to {13107, 65535, 0}
        set ANSI bright yellow color to {65535, 0, 39321}
        set ANSI bright blue color to {0, 26214, 65535}
        set ANSI bright magenta color to {52428, 0, 65535}
        set ANSI bright cyan color to {0, 65535, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
