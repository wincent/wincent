(*
    base16 Purpledream
    Scheme author: malet
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 1285, 4112}
        set foreground color to {56797, 53456, 56797}

        -- Set ANSI Colors
        set ANSI black color to {12336, 8224, 12336}
        set ANSI red color to {65535, 7453, 3341}
        set ANSI green color to {5140, 52428, 25700}
        set ANSI yellow color to {61680, 0, 41120}
        set ANSI blue color to {0, 41120, 61680}
        set ANSI magenta color to {45232, 0, 53456}
        set ANSI cyan color to {0, 30069, 45232}
        set ANSI white color to {61166, 57568, 61166}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16448, 12336, 16448}
        set ANSI bright red color to {65535, 7453, 3341}
        set ANSI bright green color to {5140, 52428, 25700}
        set ANSI bright yellow color to {61680, 0, 41120}
        set ANSI bright blue color to {0, 41120, 61680}
        set ANSI bright magenta color to {45232, 0, 53456}
        set ANSI bright cyan color to {0, 30069, 45232}
        set ANSI bright white color to {65535, 61680, 65535}
    end tell
end tell
