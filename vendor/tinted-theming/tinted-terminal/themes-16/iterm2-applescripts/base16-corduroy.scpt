(*
    base16 Corduroy
    Scheme author: taysatte (https://github.com/taysatte)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 6425, 8224}
        set foreground color to {52685, 51400, 53456}

        -- Set ANSI Colors
        set ANSI black color to {7453, 6425, 8224}
        set ANSI red color to {57568, 25186, 30840}
        set ANSI green color to {19275, 34438, 34438}
        set ANSI yellow color to {60909, 46003, 37522}
        set ANSI blue color to {53970, 32639, 37265}
        set ANSI magenta color to {49858, 34181, 45746}
        set ANSI cyan color to {59881, 40349, 37008}
        set ANSI white color to {52685, 51400, 53456}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28527, 25443, 29555}
        set ANSI bright red color to {57568, 25186, 30840}
        set ANSI bright green color to {19275, 34438, 34438}
        set ANSI bright yellow color to {60909, 46003, 37522}
        set ANSI bright blue color to {53970, 32639, 37265}
        set ANSI bright magenta color to {49858, 34181, 45746}
        set ANSI bright cyan color to {59881, 40349, 37008}
        set ANSI bright white color to {20560, 18247, 22359}
    end tell
end tell
