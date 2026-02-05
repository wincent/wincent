(*
    base16 Measured Light
    Scheme author: Measured (https://measured.co)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65021, 63993, 62965}
        set foreground color to {10537, 10537, 10537}

        -- Set ANSI Colors
        set ANSI black color to {65021, 63993, 62965}
        set ANSI red color to {44204, 7967, 13621}
        set ANSI green color to {3084, 26728, 3084}
        set ANSI yellow color to {25700, 23130, 0}
        set ANSI blue color to {257, 22616, 44461}
        set ANSI magenta color to {26214, 17733, 49858}
        set ANSI cyan color to {257, 29041, 28527}
        set ANSI white color to {10537, 10537, 10537}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23130, 23130, 23130}
        set ANSI bright red color to {44204, 7967, 13621}
        set ANSI bright green color to {3084, 26728, 3084}
        set ANSI bright yellow color to {25700, 23130, 0}
        set ANSI bright blue color to {257, 22616, 44461}
        set ANSI bright magenta color to {26214, 17733, 49858}
        set ANSI bright cyan color to {257, 29041, 28527}
        set ANSI bright white color to {0, 0, 0}
    end tell
end tell
