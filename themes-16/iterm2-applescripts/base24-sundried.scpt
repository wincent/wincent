(*
    base24 Sundried
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 6168, 6168}
        set foreground color to {43433, 43433, 42919}

        -- Set ANSI Colors
        set ANSI black color to {12336, 11051, 10794}
        set ANSI red color to {42662, 17990, 15677}
        set ANSI green color to {22359, 30326, 17476}
        set ANSI yellow color to {30840, 39064, 63479}
        set ANSI blue color to {18504, 23130, 39064}
        set ANSI magenta color to {34181, 17733, 20817}
        set ANSI cyan color to {40092, 33153, 20046}
        set ANSI white color to {51400, 51400, 51400}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {19789, 19789, 18247}
        set ANSI bright red color to {43690, 0, 3084}
        set ANSI bright green color to {4626, 35980, 8224}
        set ANSI bright yellow color to {64764, 27242, 8224}
        set ANSI bright blue color to {30840, 39064, 63479}
        set ANSI bright magenta color to {64764, 35209, 41120}
        set ANSI bright cyan color to {64250, 54227, 33924}
        set ANSI bright white color to {65535, 65278, 65278}
    end tell
end tell
