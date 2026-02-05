(*
    base24 One Light
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {59367, 59367, 59881}
        set foreground color to {14392, 14906, 16962}

        -- Set ANSI Colors
        set ANSI black color to {59367, 59367, 59881}
        set ANSI red color to {51914, 4626, 17219}
        set ANSI green color to {20560, 41377, 20303}
        set ANSI yellow color to {65278, 48059, 10794}
        set ANSI blue color to {16448, 30840, 62194}
        set ANSI magenta color to {42662, 9766, 42148}
        set ANSI cyan color to {257, 33924, 48316}
        set ANSI white color to {14392, 14906, 16962}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {41120, 41377, 42919}
        set ANSI bright red color to {60652, 8738, 22616}
        set ANSI bright green color to {28013, 47031, 27756}
        set ANSI bright yellow color to {62708, 42919, 257}
        set ANSI bright blue color to {28784, 39578, 62965}
        set ANSI bright magenta color to {53456, 12079, 52685}
        set ANSI bright cyan color to {257, 42919, 61423}
        set ANSI bright white color to {2313, 2570, 2827}
    end tell
end tell
