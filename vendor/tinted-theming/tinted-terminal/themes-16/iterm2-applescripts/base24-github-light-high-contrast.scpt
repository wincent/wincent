(*
    base24 Github Light High Contrast
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {17733, 19532, 21588}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {41120, 4369, 7967}
        set ANSI green color to {514, 19532, 6682}
        set ANSI yellow color to {24672, 14135, 0}
        set ANSI blue color to {771, 18761, 46260}
        set ANSI magenta color to {25186, 11308, 48316}
        set ANSI cyan color to {6939, 31868, 33667}
        set ANSI white color to {17733, 19532, 21588}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {33153, 35723, 39064}
        set ANSI bright red color to {34438, 1542, 7453}
        set ANSI bright green color to {1285, 23901, 8224}
        set ANSI bright yellow color to {20046, 11308, 0}
        set ANSI bright blue color to {4369, 26728, 58339}
        set ANSI bright magenta color to {33924, 19018, 59367}
        set ANSI bright cyan color to {12593, 37522, 43690}
        set ANSI bright white color to {257, 1028, 2313}
    end tell
end tell
