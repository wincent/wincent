(*
    base24 Highway
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8738, 9252}
        set foreground color to {51400, 50629, 50372}

        -- Set ANSI Colors
        set ANSI black color to {8481, 8738, 9252}
        set ANSI red color to {53199, 3341, 5911}
        set ANSI green color to {4626, 32896, 13107}
        set ANSI yellow color to {20303, 49858, 65021}
        set ANSI blue color to {0, 27242, 46003}
        set ANSI magenta color to {27242, 9766, 29812}
        set ANSI cyan color to {14392, 17733, 25443}
        set ANSI white color to {51400, 50629, 50372}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32896, 30326, 29298}
        set ANSI bright red color to {61423, 32125, 5911}
        set ANSI bright green color to {45489, 53713, 12336}
        set ANSI bright yellow color to {65535, 61937, 7967}
        set ANSI bright blue color to {20303, 49858, 65021}
        set ANSI bright magenta color to {57054, 0, 28784}
        set ANSI bright cyan color to {23644, 20303, 18761}
        set ANSI bright white color to {65278, 65535, 65278}
    end tell
end tell
