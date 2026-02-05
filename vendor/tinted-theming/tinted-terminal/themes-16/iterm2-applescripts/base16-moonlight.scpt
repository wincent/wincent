(*
    base16 Moonlight
    Scheme author: Jeremy Swinarton (https://github.com/jswinarton)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8995, 14135}
        set foreground color to {41891, 44204, 57825}

        -- Set ANSI Colors
        set ANSI black color to {8481, 8995, 14135}
        set ANSI red color to {65535, 21331, 28784}
        set ANSI green color to {11565, 62708, 49344}
        set ANSI yellow color to {65535, 51143, 30583}
        set ANSI blue color to {16448, 65535, 65535}
        set ANSI magenta color to {47545, 38036, 61937}
        set ANSI cyan color to {1028, 53713, 63993}
        set ANSI white color to {41891, 44204, 57825}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29812, 35980, 54998}
        set ANSI bright red color to {65535, 21331, 28784}
        set ANSI bright green color to {11565, 62708, 49344}
        set ANSI bright yellow color to {65535, 51143, 30583}
        set ANSI bright blue color to {16448, 65535, 65535}
        set ANSI bright magenta color to {47545, 38036, 61937}
        set ANSI bright cyan color to {1028, 53713, 63993}
        set ANSI bright white color to {61423, 17219, 64250}
    end tell
end tell
