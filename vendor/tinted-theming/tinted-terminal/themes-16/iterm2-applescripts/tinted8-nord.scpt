(*
    tinted8 Nord
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11822, 16448, 16448}
        set foreground color to {58853, 61680, 61680}

        -- Set ANSI Colors
        set ANSI black color to {11822, 16448, 16448}
        set ANSI red color to {49087, 27242, 27242}
        set ANSI green color to {41891, 35980, 35980}
        set ANSI yellow color to {60395, 35723, 35723}
        set ANSI blue color to {33153, 49601, 49601}
        set ANSI magenta color to {46260, 44461, 44461}
        set ANSI cyan color to {34952, 53456, 53456}
        set ANSI white color to {58853, 61680, 61680}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17990, 25957, 25957}
        set ANSI bright red color to {53713, 37779, 37779}
        set ANSI bright green color to {49858, 46003, 46003}
        set ANSI bright yellow color to {62708, 49087, 49087}
        set ANSI bright blue color to {43690, 54741, 54741}
        set ANSI bright magenta color to {52428, 51400, 51400}
        set ANSI bright cyan color to {46260, 57825, 57825}
        set ANSI bright white color to {60652, 62708, 62708}
    end tell
end tell
