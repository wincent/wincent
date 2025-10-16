(*
    base24 Bluloco Dark
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 8224, 10023}
        set foreground color to {45489, 47802, 51657}

        -- Set ANSI Colors
        set ANSI black color to {18761, 20303, 23644}
        set ANSI red color to {63479, 4112, 16705}
        set ANSI green color to {8995, 38807, 19018}
        set ANSI yellow color to {6168, 40863, 65021}
        set ANSI blue color to {10280, 23130, 65278}
        set ANSI magenta color to {35980, 25186, 65021}
        set ANSI cyan color to {13878, 28527, 39321}
        set ANSI white color to {52428, 54741, 58596}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24672, 26985, 31354}
        set ANSI bright red color to {64507, 18761, 28013}
        set ANSI bright green color to {14135, 48316, 22616}
        set ANSI bright yellow color to {63222, 48573, 18247}
        set ANSI bright blue color to {6168, 40863, 65021}
        set ANSI bright magenta color to {64507, 22359, 63222}
        set ANSI bright cyan color to {20303, 43947, 44461}
        set ANSI bright white color to {65278, 65278, 65278}
    end tell
end tell
