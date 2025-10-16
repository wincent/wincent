(*
    base16 Evenok Dark
    Scheme author: Mekeor Melire
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8224, 8224}
        set ANSI red color to {62965, 28784, 35466}
        set ANSI green color to {21588, 48316, 23644}
        set ANSI yellow color to {47288, 41891, 0}
        set ANSI blue color to {0, 44975, 62194}
        set ANSI magenta color to {37008, 38293, 65535}
        set ANSI cyan color to {0, 47802, 46003}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12336, 12336, 12336}
        set ANSI bright red color to {62965, 28784, 35466}
        set ANSI bright green color to {21588, 48316, 23644}
        set ANSI bright yellow color to {47288, 41891, 0}
        set ANSI bright blue color to {0, 44975, 62194}
        set ANSI bright magenta color to {37008, 38293, 65535}
        set ANSI bright cyan color to {0, 47802, 46003}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
