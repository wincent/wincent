(*
    base24 Solarized Dark Patched
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 7710, 9766}
        set foreground color to {49344, 49344, 45232}

        -- Set ANSI Colors
        set ANSI black color to {0, 10023, 12593}
        set ANSI red color to {53456, 6939, 9252}
        set ANSI green color to {29298, 35209, 1285}
        set ANSI yellow color to {28784, 33153, 33667}
        set ANSI blue color to {8224, 30069, 51143}
        set ANSI magenta color to {50886, 6939, 28270}
        set ANSI cyan color to {9509, 37265, 34181}
        set ANSI white color to {59881, 58082, 52171}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17990, 23130, 24929}
        set ANSI bright red color to {48573, 13878, 4626}
        set ANSI bright green color to {17990, 23130, 24929}
        set ANSI bright yellow color to {21074, 26471, 28527}
        set ANSI bright blue color to {28784, 33153, 33667}
        set ANSI bright magenta color to {22616, 22102, 47545}
        set ANSI bright cyan color to {33153, 37008, 36751}
        set ANSI bright white color to {64764, 62708, 56540}
    end tell
end tell
