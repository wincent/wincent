(*
    base24 Github Light High Contrast
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {13364, 15163, 17219}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {28784, 11308, 0}
        set ANSI green color to {771, 9509, 25443}
        set ANSI yellow color to {38293, 25700, 0}
        set ANSI blue color to {25186, 11308, 48316}
        set ANSI magenta color to {41120, 4369, 7967}
        set ANSI cyan color to {514, 19532, 6682}
        set ANSI white color to {13364, 15163, 17219}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {34952, 37522, 40349}
        set ANSI bright red color to {61166, 23130, 23901}
        set ANSI bright green color to {9766, 41377, 18504}
        set ANSI bright yellow color to {46517, 33924, 1799}
        set ANSI bright blue color to {13878, 35980, 63993}
        set ANSI bright magenta color to {41891, 29041, 63479}
        set ANSI bright cyan color to {18761, 48316, 47031}
        set ANSI bright white color to {3598, 4369, 5654}
    end tell
end tell
