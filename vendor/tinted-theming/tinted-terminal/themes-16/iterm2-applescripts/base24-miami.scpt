(*
    base24 Miami
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {63479, 61937, 65535}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 19532, 35723}
        set ANSI green color to {32639, 65535, 54484}
        set ANSI yellow color to {65535, 55512, 19532}
        set ANSI blue color to {0, 65535, 43176}
        set ANSI magenta color to {54227, 27756, 65535}
        set ANSI cyan color to {18247, 53199, 65535}
        set ANSI white color to {63479, 61937, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26985, 26471, 27756}
        set ANSI bright red color to {65535, 19532, 35723}
        set ANSI bright green color to {32639, 65535, 54484}
        set ANSI bright yellow color to {65535, 55512, 19532}
        set ANSI bright blue color to {0, 65535, 43176}
        set ANSI bright magenta color to {54227, 27756, 65535}
        set ANSI bright cyan color to {18247, 53199, 65535}
        set ANSI bright white color to {63479, 61937, 65535}
    end tell
end tell
