(*
    base16 Mellow Purple
    Scheme author: gidsi
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 1285, 10280}
        set foreground color to {65535, 61166, 65535}

        -- Set ANSI Colors
        set ANSI black color to {7710, 1285, 10280}
        set ANSI red color to {0, 55769, 59881}
        set ANSI green color to {1285, 52171, 3341}
        set ANSI yellow color to {38293, 23130, 59367}
        set ANSI blue color to {21845, 0, 26728}
        set ANSI magenta color to {35209, 37265, 48059}
        set ANSI cyan color to {47545, 0, 45489}
        set ANSI white color to {65535, 61166, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12850, 3855, 21845}
        set ANSI bright red color to {0, 55769, 59881}
        set ANSI bright green color to {1285, 52171, 3341}
        set ANSI bright yellow color to {38293, 23130, 59367}
        set ANSI bright blue color to {21845, 0, 26728}
        set ANSI bright magenta color to {35209, 37265, 48059}
        set ANSI bright cyan color to {47545, 0, 45489}
        set ANSI bright white color to {63736, 49344, 65535}
    end tell
end tell
