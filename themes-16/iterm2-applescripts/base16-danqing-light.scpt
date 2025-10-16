(*
    base16 DanQing Light
    Scheme author: Wenhan Zhu (Cosmos) (zhuwenhan950913@gmail.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64764, 65278, 65021}
        set foreground color to {23130, 24672, 23901}

        -- Set ANSI Colors
        set ANSI black color to {60652, 63222, 62194}
        set ANSI red color to {63993, 37008, 28527}
        set ANSI green color to {35466, 46003, 24929}
        set ANSI yellow color to {61680, 49858, 14649}
        set ANSI blue color to {45232, 42148, 58339}
        set ANSI magenta color to {52428, 42148, 58339}
        set ANSI cyan color to {12336, 57311, 62451}
        set ANSI white color to {17219, 18504, 17990}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {57568, 61680, 61423}
        set ANSI bright red color to {63993, 37008, 28527}
        set ANSI bright green color to {35466, 46003, 24929}
        set ANSI bright yellow color to {61680, 49858, 14649}
        set ANSI bright blue color to {45232, 42148, 58339}
        set ANSI bright magenta color to {52428, 42148, 58339}
        set ANSI bright cyan color to {12336, 57311, 62451}
        set ANSI bright white color to {11565, 12336, 12079}
    end tell
end tell
