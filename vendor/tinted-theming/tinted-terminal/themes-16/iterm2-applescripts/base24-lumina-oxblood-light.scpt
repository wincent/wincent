(*
    base24 Lumina Oxblood Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65278, 62194, 62708}
        set foreground color to {16962, 8738, 12079}

        -- Set ANSI Colors
        set ANSI black color to {65278, 62194, 62708}
        set ANSI red color to {39835, 10280, 10023}
        set ANSI green color to {8995, 30583, 16962}
        set ANSI yellow color to {41377, 24672, 2570}
        set ANSI blue color to {12593, 26214, 42662}
        set ANSI magenta color to {25957, 22102, 41891}
        set ANSI cyan color to {2056, 29555, 32896}
        set ANSI white color to {16962, 8738, 12079}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {57054, 52942, 53713}
        set ANSI bright red color to {29555, 10537, 9766}
        set ANSI bright green color to {3855, 24929, 12593}
        set ANSI bright yellow color to {34695, 20046, 0}
        set ANSI bright blue color to {7196, 21074, 37008}
        set ANSI bright magenta color to {26728, 14906, 32125}
        set ANSI bright cyan color to {0, 23901, 26728}
        set ANSI bright white color to {16962, 8738, 12079}
    end tell
end tell
