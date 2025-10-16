(*
    base16 One Light
    Scheme author: Daniel Pfeifer (http://github.com/purpleKarrot)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64250, 64250, 64250}
        set foreground color to {14392, 14906, 16962}

        -- Set ANSI Colors
        set ANSI black color to {61680, 61680, 61937}
        set ANSI red color to {51914, 4626, 17219}
        set ANSI green color to {20560, 41377, 20303}
        set ANSI yellow color to {49601, 33924, 257}
        set ANSI blue color to {16448, 30840, 62194}
        set ANSI magenta color to {42662, 9766, 42148}
        set ANSI cyan color to {257, 33924, 48316}
        set ANSI white color to {8224, 8738, 10023}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {58853, 58853, 59110}
        set ANSI bright red color to {51914, 4626, 17219}
        set ANSI bright green color to {20560, 41377, 20303}
        set ANSI bright yellow color to {49601, 33924, 257}
        set ANSI bright blue color to {16448, 30840, 62194}
        set ANSI bright magenta color to {42662, 9766, 42148}
        set ANSI bright cyan color to {257, 33924, 48316}
        set ANSI bright white color to {2313, 2570, 2827}
    end tell
end tell
