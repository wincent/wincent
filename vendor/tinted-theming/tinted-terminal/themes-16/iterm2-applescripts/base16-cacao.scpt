(*
    base16 Cacao
    Scheme author: Teshre
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 3855, 3084}
        set foreground color to {59624, 54998, 50372}

        -- Set ANSI Colors
        set ANSI black color to {5654, 3855, 3084}
        set ANSI red color to {57568, 28784, 23644}
        set ANSI green color to {39578, 51657, 31354}
        set ANSI yellow color to {59624, 43176, 19018}
        set ANSI blue color to {43176, 39578, 53456}
        set ANSI magenta color to {52942, 35466, 45232}
        set ANSI cyan color to {29812, 51400, 45232}
        set ANSI white color to {59624, 54998, 50372}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30326, 24672, 21074}
        set ANSI bright red color to {57568, 28784, 23644}
        set ANSI bright green color to {39578, 51657, 31354}
        set ANSI bright yellow color to {59624, 43176, 19018}
        set ANSI bright blue color to {43176, 39578, 53456}
        set ANSI bright magenta color to {52942, 35466, 45232}
        set ANSI bright cyan color to {29812, 51400, 45232}
        set ANSI bright white color to {62708, 59110, 54998}
    end tell
end tell
