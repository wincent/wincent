(*
    base24 Github
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62708, 62708, 62708}
        set foreground color to {55512, 55512, 55512}

        -- Set ANSI Colors
        set ANSI black color to {15934, 15934, 15934}
        set ANSI red color to {38807, 2827, 5654}
        set ANSI green color to {1799, 38550, 10794}
        set ANSI yellow color to {11822, 27756, 47802}
        set ANSI blue color to {0, 15934, 35466}
        set ANSI magenta color to {59881, 17990, 37265}
        set ANSI cyan color to {35209, 53713, 60652}
        set ANSI white color to {65535, 65535, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 26214, 26214}
        set ANSI bright red color to {57054, 0, 0}
        set ANSI bright green color to {34695, 54741, 41634}
        set ANSI bright yellow color to {61937, 53456, 1799}
        set ANSI bright blue color to {11822, 27756, 47802}
        set ANSI bright magenta color to {65535, 41634, 40863}
        set ANSI bright cyan color to {7196, 64250, 65278}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
