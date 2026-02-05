(*
    base24 CLRS
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {39578, 39835, 39578}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {63479, 10023, 10537}
        set ANSI green color to {12850, 35209, 23644}
        set ANSI yellow color to {5397, 28527, 65278}
        set ANSI blue color to {4626, 23644, 53199}
        set ANSI magenta color to {40863, 0, 48316}
        set ANSI cyan color to {12850, 49858, 49344}
        set ANSI white color to {39578, 39835, 39578}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27499, 28013, 27242}
        set ANSI bright red color to {64507, 1028, 5654}
        set ANSI bright green color to {11308, 50886, 12593}
        set ANSI bright yellow color to {64764, 54998, 10023}
        set ANSI bright blue color to {5397, 28527, 65278}
        set ANSI bright magenta color to {59624, 0, 45232}
        set ANSI bright cyan color to {14649, 54741, 52942}
        set ANSI bright white color to {60909, 60909, 60652}
    end tell
end tell
