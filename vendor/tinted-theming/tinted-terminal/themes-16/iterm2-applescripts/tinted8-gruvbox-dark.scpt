(*
    tinted8 Gruvbox Dark
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 10280, 10280}
        set foreground color to {60395, 45746, 45746}

        -- Set ANSI Colors
        set ANSI black color to {10280, 10280, 10280}
        set ANSI red color to {52428, 7453, 7453}
        set ANSI green color to {39064, 6682, 6682}
        set ANSI yellow color to {55255, 8481, 8481}
        set ANSI blue color to {17733, 34952, 34952}
        set ANSI magenta color to {45489, 34438, 34438}
        set ANSI cyan color to {26728, 27242, 27242}
        set ANSI white color to {60395, 45746, 45746}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15420, 13878, 13878}
        set ANSI bright red color to {64507, 13364, 13364}
        set ANSI bright green color to {47288, 9766, 9766}
        set ANSI bright yellow color to {64250, 12079, 12079}
        set ANSI bright blue color to {33667, 39064, 39064}
        set ANSI bright magenta color to {54227, 39835, 39835}
        set ANSI bright cyan color to {36494, 31868, 31868}
        set ANSI bright white color to {64507, 51143, 51143}
    end tell
end tell
