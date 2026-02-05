(*
    base24 Idea
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 8224, 8224}
        set foreground color to {20817, 20817, 20817}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8224, 8224}
        set ANSI red color to {64507, 21074, 21845}
        set ANSI green color to {39064, 46774, 6939}
        set ANSI yellow color to {27756, 39835, 60909}
        set ANSI blue color to {17219, 32382, 59110}
        set ANSI magenta color to {40349, 29555, 45232}
        set ANSI cyan color to {9252, 34952, 34438}
        set ANSI white color to {20817, 20817, 20817}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {50629, 50629, 50629}
        set ANSI bright red color to {64764, 28527, 29298}
        set ANSI bright green color to {39064, 46774, 6939}
        set ANSI bright yellow color to {65535, 65535, 2570}
        set ANSI bright blue color to {27756, 39835, 60909}
        set ANSI bright magenta color to {64764, 32382, 65278}
        set ANSI bright cyan color to {9252, 34952, 34438}
        set ANSI bright white color to {5911, 5911, 5911}
    end tell
end tell
