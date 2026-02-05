(*
    base24 Smyck
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 6939, 6939}
        set foreground color to {38550, 38550, 38550}

        -- Set ANSI Colors
        set ANSI black color to {6939, 6939, 6939}
        set ANSI red color to {47031, 16705, 12593}
        set ANSI green color to {32125, 43433, 0}
        set ANSI yellow color to {36237, 53199, 61680}
        set ANSI blue color to {25186, 41891, 50372}
        set ANSI magenta color to {47545, 35466, 52428}
        set ANSI cyan color to {8224, 29555, 33667}
        set ANSI white color to {38550, 38550, 38550}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {33667, 33667, 33667}
        set ANSI bright red color to {54998, 33667, 31611}
        set ANSI bright green color to {50372, 61680, 13878}
        set ANSI bright yellow color to {65278, 57825, 19789}
        set ANSI bright blue color to {36237, 53199, 61680}
        set ANSI bright magenta color to {63479, 39321, 65535}
        set ANSI bright cyan color to {26985, 55769, 53199}
        set ANSI bright white color to {63479, 63479, 63479}
    end tell
end tell
