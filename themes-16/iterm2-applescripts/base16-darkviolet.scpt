(*
    base16 Dark Violet
    Scheme author: ruler501 (https://github.com/ruler501/base16-darkviolet)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {45232, 35466, 59110}

        -- Set ANSI Colors
        set ANSI black color to {8995, 6682, 16448}
        set ANSI red color to {43176, 11822, 59110}
        set ANSI green color to {17733, 38293, 59110}
        set ANSI yellow color to {62194, 40349, 62194}
        set ANSI blue color to {16705, 13878, 55769}
        set ANSI magenta color to {32382, 23644, 59110}
        set ANSI cyan color to {16448, 57311, 65535}
        set ANSI white color to {37008, 17733, 59110}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17219, 11565, 22873}
        set ANSI bright red color to {43176, 11822, 59110}
        set ANSI bright green color to {17733, 38293, 59110}
        set ANSI bright yellow color to {62194, 40349, 62194}
        set ANSI bright blue color to {16705, 13878, 55769}
        set ANSI bright magenta color to {32382, 23644, 59110}
        set ANSI bright cyan color to {16448, 57311, 65535}
        set ANSI bright white color to {41891, 26214, 65535}
    end tell
end tell
