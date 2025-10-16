(*
    base24 Ollie
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8224, 9252}
        set foreground color to {32382, 30583, 35209}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {43947, 11822, 12336}
        set ANSI green color to {12593, 43947, 24672}
        set ANSI yellow color to {17476, 34695, 65535}
        set ANSI blue color to {11308, 22102, 43947}
        set ANSI magenta color to {44975, 33924, 10023}
        set ANSI cyan color to {7967, 42405, 43947}
        set ANSI white color to {35466, 36237, 43947}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23130, 13878, 9509}
        set ANSI bright red color to {65535, 15677, 18504}
        set ANSI bright green color to {15163, 65535, 39321}
        set ANSI bright yellow color to {65535, 24158, 7710}
        set ANSI bright blue color to {17476, 34695, 65535}
        set ANSI bright magenta color to {65535, 49858, 7196}
        set ANSI bright cyan color to {7710, 64250, 65535}
        set ANSI bright white color to {23387, 28013, 42919}
    end tell
end tell
