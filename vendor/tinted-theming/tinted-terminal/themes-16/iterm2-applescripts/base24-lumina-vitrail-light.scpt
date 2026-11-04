(*
    base24 Lumina Vitrail Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64764, 64250, 62708}
        set foreground color to {3855, 5140, 7453}

        -- Set ANSI Colors
        set ANSI black color to {64764, 64250, 62708}
        set ANSI red color to {30069, 8738, 0}
        set ANSI green color to {0, 18761, 3855}
        set ANSI yellow color to {31868, 18247, 0}
        set ANSI blue color to {5911, 10537, 45746}
        set ANSI magenta color to {18761, 12593, 36494}
        set ANSI cyan color to {0, 23387, 29298}
        set ANSI white color to {3855, 5140, 7453}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {56026, 55255, 53199}
        set ANSI bright red color to {22616, 5911, 0}
        set ANSI bright green color to {0, 13364, 2056}
        set ANSI bright yellow color to {25186, 14135, 0}
        set ANSI bright blue color to {4626, 9252, 31611}
        set ANSI bright magenta color to {18504, 3341, 24158}
        set ANSI bright cyan color to {0, 17990, 22873}
        set ANSI bright white color to {3855, 5140, 7453}
    end tell
end tell
