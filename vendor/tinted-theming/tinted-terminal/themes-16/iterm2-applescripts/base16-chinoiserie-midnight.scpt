(*
    base16 Chinoiserie Midnight
    Scheme author: Di Wang (https://cs.cmu.edu/~diw3)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 7453, 7453}
        set foreground color to {50372, 52171, 53199}

        -- Set ANSI Colors
        set ANSI black color to {7453, 7453, 7453}
        set ANSI red color to {60909, 23130, 22102}
        set ANSI green color to {44718, 47288, 12593}
        set ANSI yellow color to {64507, 47545, 22359}
        set ANSI blue color to {33153, 41634, 41634}
        set ANSI magenta color to {53199, 35209, 38807}
        set ANSI cyan color to {34952, 46774, 36237}
        set ANSI white color to {50372, 52171, 53199}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {37265, 32896, 29298}
        set ANSI bright red color to {60909, 23130, 22102}
        set ANSI bright green color to {44718, 47288, 12593}
        set ANSI bright yellow color to {64507, 47545, 22359}
        set ANSI bright blue color to {33153, 41634, 41634}
        set ANSI bright magenta color to {53199, 35209, 38807}
        set ANSI bright cyan color to {34952, 46774, 36237}
        set ANSI bright white color to {65535, 65278, 63993}
    end tell
end tell
