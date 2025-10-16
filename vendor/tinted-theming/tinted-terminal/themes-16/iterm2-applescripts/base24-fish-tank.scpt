(*
    base24 Fish Tank
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8738, 9252, 13878}
        set foreground color to {52428, 51657, 51657}

        -- Set ANSI Colors
        set ANSI black color to {771, 1542, 15420}
        set ANSI red color to {50886, 0, 18761}
        set ANSI green color to {43947, 61937, 22359}
        set ANSI yellow color to {45489, 48573, 63993}
        set ANSI blue color to {21074, 24415, 47288}
        set ANSI magenta color to {38807, 28527, 33153}
        set ANSI cyan color to {38550, 34438, 25186}
        set ANSI white color to {60652, 61423, 64764}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27756, 23130, 12336}
        set ANSI bright red color to {55769, 19018, 35466}
        set ANSI bright green color to {56026, 65535, 43176}
        set ANSI bright yellow color to {65278, 59110, 43176}
        set ANSI bright blue color to {45489, 48573, 63993}
        set ANSI bright magenta color to {65021, 42148, 52428}
        set ANSI bright cyan color to {42148, 48316, 34438}
        set ANSI bright white color to {63222, 65535, 60652}
    end tell
end tell
