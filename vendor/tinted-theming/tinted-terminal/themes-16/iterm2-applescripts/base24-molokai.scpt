(*
    base24 Molokai
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4626, 4626, 4626}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {4626, 4626, 4626}
        set ANSI red color to {64250, 9509, 29555}
        set ANSI green color to {38807, 57825, 8995}
        set ANSI yellow color to {0, 44975, 65535}
        set ANSI blue color to {3855, 32639, 53199}
        set ANSI magenta color to {34695, 0, 65535}
        set ANSI cyan color to {16962, 42919, 53199}
        set ANSI white color to {41377, 41377, 41377}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 28270, 28270}
        set ANSI bright red color to {62965, 26214, 40092}
        set ANSI bright green color to {45232, 57568, 24158}
        set ANSI bright yellow color to {65278, 62194, 27756}
        set ANSI bright blue color to {0, 44975, 65535}
        set ANSI bright magenta color to {44975, 34695, 65535}
        set ANSI bright cyan color to {20560, 52685, 65278}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
