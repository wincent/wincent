(*
    base16 summercamp
    Scheme author: zoe firi (zoefiri.github.io)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 6168, 4112}
        set foreground color to {29555, 28270, 21845}

        -- Set ANSI Colors
        set ANSI black color to {10794, 9766, 7196}
        set ANSI red color to {58339, 20817, 16962}
        set ANSI green color to {23644, 60395, 23130}
        set ANSI yellow color to {62194, 65535, 10023}
        set ANSI blue color to {18504, 39835, 61680}
        set ANSI magenta color to {65535, 32896, 32896}
        set ANSI cyan color to {23130, 60395, 48316}
        set ANSI white color to {47802, 46774, 38550}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14906, 13621, 10023}
        set ANSI bright red color to {58339, 20817, 16962}
        set ANSI bright green color to {23644, 60395, 23130}
        set ANSI bright yellow color to {62194, 65535, 10023}
        set ANSI bright blue color to {18504, 39835, 61680}
        set ANSI bright magenta color to {65535, 32896, 32896}
        set ANSI bright cyan color to {23130, 60395, 48316}
        set ANSI bright white color to {63736, 62965, 57054}
    end tell
end tell
