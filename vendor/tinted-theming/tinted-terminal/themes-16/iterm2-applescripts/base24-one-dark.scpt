(*
    base24 One Dark
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 11308, 13364}
        set foreground color to {43947, 45746, 49087}

        -- Set ANSI Colors
        set ANSI black color to {16191, 17476, 20817}
        set ANSI red color to {57568, 21845, 24929}
        set ANSI green color to {35980, 49858, 25957}
        set ANSI yellow color to {59110, 47545, 25957}
        set ANSI blue color to {19018, 42405, 61680}
        set ANSI magenta color to {49601, 25186, 57054}
        set ANSI cyan color to {16962, 46003, 49858}
        set ANSI white color to {59110, 59110, 59110}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20303, 22102, 26214}
        set ANSI bright red color to {65535, 24929, 28270}
        set ANSI bright green color to {42405, 57568, 30069}
        set ANSI bright yellow color to {61680, 42148, 23901}
        set ANSI bright blue color to {19789, 50372, 65535}
        set ANSI bright magenta color to {57054, 29555, 65535}
        set ANSI bright cyan color to {19532, 53713, 57568}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
