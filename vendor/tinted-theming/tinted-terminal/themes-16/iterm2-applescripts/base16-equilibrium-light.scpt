(*
    base16 Equilibrium Light
    Scheme author: Carlo Abelli
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62965, 61680, 59367}
        set foreground color to {17219, 18247, 20046}

        -- Set ANSI Colors
        set ANSI black color to {62965, 61680, 59367}
        set ANSI red color to {53456, 8224, 8995}
        set ANSI green color to {25443, 29298, 0}
        set ANSI yellow color to {40349, 28527, 0}
        set ANSI blue color to {0, 29555, 46517}
        set ANSI magenta color to {20046, 26214, 46774}
        set ANSI cyan color to {0, 31354, 29298}
        set ANSI white color to {17219, 18247, 20046}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29555, 30583, 32639}
        set ANSI bright red color to {53456, 8224, 8995}
        set ANSI bright green color to {25443, 29298, 0}
        set ANSI bright yellow color to {40349, 28527, 0}
        set ANSI bright blue color to {0, 29555, 46517}
        set ANSI bright magenta color to {20046, 26214, 46774}
        set ANSI bright cyan color to {0, 31354, 29298}
        set ANSI bright white color to {6168, 7196, 8738}
    end tell
end tell
