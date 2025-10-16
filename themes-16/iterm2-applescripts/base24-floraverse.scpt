(*
    base24 Floraverse
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3598, 3084, 5397}
        set foreground color to {50115, 44975, 40349}

        -- Set ANSI Colors
        set ANSI black color to {2056, 0, 11822}
        set ANSI red color to {25700, 0, 11308}
        set ANSI green color to {23901, 29555, 6682}
        set ANSI yellow color to {16448, 42148, 53199}
        set ANSI blue color to {7453, 28013, 41377}
        set ANSI magenta color to {47031, 1799, 32382}
        set ANSI cyan color to {16962, 41891, 35980}
        set ANSI white color to {62451, 57568, 47288}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13107, 7710, 19789}
        set ANSI bright red color to {53456, 8224, 25443}
        set ANSI bright green color to {46260, 52942, 22873}
        set ANSI bright yellow color to {64250, 50115, 22359}
        set ANSI bright blue color to {16448, 42148, 53199}
        set ANSI bright magenta color to {61937, 10794, 44718}
        set ANSI bright cyan color to {25186, 51914, 43176}
        set ANSI bright white color to {65535, 62965, 56283}
    end tell
end tell
