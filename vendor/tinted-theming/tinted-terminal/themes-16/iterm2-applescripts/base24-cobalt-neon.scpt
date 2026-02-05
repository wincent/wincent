(*
    base24 Cobalt Neon
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5140, 10280, 14392}
        set foreground color to {52428, 29298, 42662}

        -- Set ANSI Colors
        set ANSI black color to {5140, 10280, 14392}
        set ANSI red color to {65535, 8995, 8224}
        set ANSI green color to {14906, 42405, 65535}
        set ANSI yellow color to {15420, 32125, 53970}
        set ANSI blue color to {36751, 62965, 34438}
        set ANSI magenta color to {30840, 6682, 41120}
        set ANSI cyan color to {36751, 62965, 34438}
        set ANSI white color to {52428, 29298, 42662}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {61166, 51914, 37522}
        set ANSI bright red color to {54484, 12593, 11822}
        set ANSI bright green color to {36751, 62965, 34438}
        set ANSI bright yellow color to {59881, 61680, 28013}
        set ANSI bright blue color to {15420, 32125, 53970}
        set ANSI bright magenta color to {33410, 12336, 42919}
        set ANSI bright cyan color to {27756, 48316, 26471}
        set ANSI bright white color to {36751, 62965, 34438}
    end tell
end tell
