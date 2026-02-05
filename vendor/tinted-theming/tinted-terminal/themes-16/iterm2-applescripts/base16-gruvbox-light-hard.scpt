(*
    base16 Gruvbox light, hard
    Scheme author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63993, 62965, 55255}
        set foreground color to {20560, 18761, 17733}

        -- Set ANSI Colors
        set ANSI black color to {63993, 62965, 55255}
        set ANSI red color to {40349, 0, 1542}
        set ANSI green color to {31097, 29812, 3598}
        set ANSI yellow color to {46517, 30326, 5140}
        set ANSI blue color to {1799, 26214, 30840}
        set ANSI magenta color to {36751, 16191, 29041}
        set ANSI cyan color to {16962, 31611, 22616}
        set ANSI white color to {20560, 18761, 17733}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {48573, 44718, 37779}
        set ANSI bright red color to {40349, 0, 1542}
        set ANSI bright green color to {31097, 29812, 3598}
        set ANSI bright yellow color to {46517, 30326, 5140}
        set ANSI bright blue color to {1799, 26214, 30840}
        set ANSI bright magenta color to {36751, 16191, 29041}
        set ANSI bright cyan color to {16962, 31611, 22616}
        set ANSI bright white color to {10280, 10280, 10280}
    end tell
end tell
