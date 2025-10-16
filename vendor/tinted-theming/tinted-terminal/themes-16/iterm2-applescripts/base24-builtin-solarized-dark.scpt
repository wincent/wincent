(*
    base24 Builtin Solarized Dark
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 11051, 13878}
        set foreground color to {45746, 47288, 44461}

        -- Set ANSI Colors
        set ANSI black color to {1799, 13878, 16962}
        set ANSI red color to {56540, 12850, 12079}
        set ANSI green color to {34181, 39321, 0}
        set ANSI yellow color to {33667, 38036, 38550}
        set ANSI blue color to {9766, 35723, 53970}
        set ANSI magenta color to {54227, 13878, 33410}
        set ANSI cyan color to {10794, 41377, 39064}
        set ANSI white color to {61166, 59624, 54741}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {0, 11051, 13878}
        set ANSI bright red color to {52171, 19275, 5654}
        set ANSI bright green color to {22616, 28270, 30069}
        set ANSI bright yellow color to {25957, 31611, 33667}
        set ANSI bright blue color to {33667, 38036, 38550}
        set ANSI bright magenta color to {27756, 29041, 50372}
        set ANSI bright cyan color to {37779, 41377, 41377}
        set ANSI bright white color to {65021, 63222, 58339}
    end tell
end tell
