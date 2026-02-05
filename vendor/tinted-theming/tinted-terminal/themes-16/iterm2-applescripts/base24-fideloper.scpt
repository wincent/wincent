(*
    base24 Fideloper
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 12079, 12850}
        set foreground color to {45489, 45489, 41891}

        -- Set ANSI Colors
        set ANSI black color to {10280, 12079, 12850}
        set ANSI red color to {51914, 7453, 11308}
        set ANSI green color to {60909, 47031, 43947}
        set ANSI yellow color to {31868, 33924, 50372}
        set ANSI blue color to {11822, 30840, 49601}
        set ANSI magenta color to {49344, 8738, 28270}
        set ANSI cyan color to {12336, 37265, 34181}
        set ANSI white color to {45489, 45489, 41891}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16705, 20560, 20560}
        set ANSI bright red color to {54227, 24415, 23130}
        set ANSI bright green color to {54227, 24415, 23130}
        set ANSI bright yellow color to {43176, 25957, 29041}
        set ANSI bright blue color to {31868, 33924, 50372}
        set ANSI bright magenta color to {23387, 23901, 45746}
        set ANSI bright cyan color to {33153, 37008, 36751}
        set ANSI bright white color to {64764, 62708, 57054}
    end tell
end tell
