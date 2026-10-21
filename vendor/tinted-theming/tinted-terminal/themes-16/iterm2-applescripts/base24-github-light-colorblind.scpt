(*
    base24 Github Light Colorblind
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {17733, 19532, 21588}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {48316, 19532, 0}
        set ANSI green color to {1285, 20560, 44718}
        set ANSI yellow color to {39578, 26471, 0}
        set ANSI blue color to {2313, 26985, 56026}
        set ANSI magenta color to {33410, 20560, 57311}
        set ANSI cyan color to {6939, 31868, 33667}
        set ANSI white color to {17733, 19532, 21588}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {33153, 35723, 39064}
        set ANSI bright red color to {38293, 14392, 0}
        set ANSI bright green color to {2313, 26985, 56026}
        set ANSI bright yellow color to {25443, 15420, 257}
        set ANSI bright blue color to {8481, 35723, 65535}
        set ANSI bright magenta color to {42148, 30069, 63993}
        set ANSI bright cyan color to {12593, 37522, 43690}
        set ANSI bright white color to {7967, 8995, 10280}
    end tell
end tell
