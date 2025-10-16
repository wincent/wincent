(*
    base24 Elementary
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 6168, 6168}
        set foreground color to {50629, 50629, 50629}

        -- Set ANSI Colors
        set ANSI black color to {9252, 9252, 9252}
        set ANSI red color to {54998, 6939, 5397}
        set ANSI green color to {22873, 42148, 4883}
        set ANSI yellow color to {2056, 21845, 65278}
        set ANSI blue color to {1285, 14906, 35980}
        set ANSI magenta color to {58596, 0, 14392}
        set ANSI cyan color to {9509, 38036, 57568}
        set ANSI white color to {61166, 61166, 61166}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {19018, 19018, 19018}
        set ANSI bright red color to {64507, 6939, 6168}
        set ANSI bright green color to {27242, 49601, 6168}
        set ANSI bright yellow color to {65021, 51143, 3598}
        set ANSI bright blue color to {2056, 21845, 65278}
        set ANSI bright magenta color to {64507, 0, 20303}
        set ANSI bright cyan color to {15934, 42919, 64764}
        set ANSI bright white color to {35980, 0, 60395}
    end tell
end tell
