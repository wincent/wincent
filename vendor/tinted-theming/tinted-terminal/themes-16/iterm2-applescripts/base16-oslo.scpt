(*
    base16 Oslo
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {16191, 17476, 20817}
        set foreground color to {43947, 45746, 49087}

        -- Set ANSI Colors
        set ANSI black color to {16191, 17476, 20817}
        set ANSI red color to {57568, 21845, 24929}
        set ANSI green color to {35980, 49858, 25957}
        set ANSI yellow color to {53713, 36751, 21074}
        set ANSI blue color to {19018, 42405, 61680}
        set ANSI magenta color to {49601, 25186, 57054}
        set ANSI cyan color to {16962, 46003, 49858}
        set ANSI white color to {43947, 45746, 49087}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27756, 29298, 32639}
        set ANSI bright red color to {57568, 21845, 24929}
        set ANSI bright green color to {35980, 49858, 25957}
        set ANSI bright yellow color to {53713, 36751, 21074}
        set ANSI bright blue color to {19018, 42405, 61680}
        set ANSI bright magenta color to {49601, 25186, 57054}
        set ANSI bright cyan color to {16962, 46003, 49858}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
