(*
    base16 Summerfruit Dark
    Scheme author: Christopher Corley (http://christop.club/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5397, 5397, 5397}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8224, 8224}
        set ANSI red color to {65535, 0, 34438}
        set ANSI green color to {0, 51657, 6168}
        set ANSI yellow color to {43947, 43176, 0}
        set ANSI blue color to {14135, 30583, 59110}
        set ANSI magenta color to {44461, 0, 41377}
        set ANSI cyan color to {7967, 43690, 43690}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12336, 12336, 12336}
        set ANSI bright red color to {65535, 0, 34438}
        set ANSI bright green color to {0, 51657, 6168}
        set ANSI bright yellow color to {43947, 43176, 0}
        set ANSI bright blue color to {14135, 30583, 59110}
        set ANSI bright magenta color to {44461, 0, 41377}
        set ANSI bright cyan color to {7967, 43690, 43690}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
