(*
    base16 standardized-dark
    Scheme author: ali (https://github.com/ali-githb/base16-standardized-scheme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8738, 8738, 8738}
        set foreground color to {49344, 49344, 49344}

        -- Set ANSI Colors
        set ANSI black color to {12336, 12336, 12336}
        set ANSI red color to {57825, 23901, 26471}
        set ANSI green color to {23901, 45489, 10537}
        set ANSI yellow color to {57825, 46003, 6682}
        set ANSI blue color to {0, 41891, 62194}
        set ANSI magenta color to {46260, 28270, 57568}
        set ANSI cyan color to {8481, 51657, 37522}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {57825, 23901, 26471}
        set ANSI bright green color to {23901, 45489, 10537}
        set ANSI bright yellow color to {57825, 46003, 6682}
        set ANSI bright blue color to {0, 41891, 62194}
        set ANSI bright magenta color to {46260, 28270, 57568}
        set ANSI bright cyan color to {8481, 51657, 37522}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
