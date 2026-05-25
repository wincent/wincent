(*
    base16 Kissa Latte
    Scheme author: rwendell (https://github.com/rwendell/kissa)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62965, 62708, 61680}
        set foreground color to {7967, 7196, 5654}

        -- Set ANSI Colors
        set ANSI black color to {62965, 62708, 61680}
        set ANSI red color to {40606, 15934, 15934}
        set ANSI green color to {14392, 28784, 20560}
        set ANSI yellow color to {32125, 26728, 8224}
        set ANSI blue color to {13364, 26728, 43176}
        set ANSI magenta color to {25700, 14392, 41120}
        set ANSI cyan color to {10280, 28784, 28784}
        set ANSI white color to {7967, 7196, 5654}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {37265, 34952, 32125}
        set ANSI bright red color to {40606, 15934, 15934}
        set ANSI bright green color to {14392, 28784, 20560}
        set ANSI bright yellow color to {32125, 26728, 8224}
        set ANSI bright blue color to {13364, 26728, 43176}
        set ANSI bright magenta color to {25700, 14392, 41120}
        set ANSI bright cyan color to {10280, 28784, 28784}
        set ANSI bright white color to {65278, 64764, 64250}
    end tell
end tell
