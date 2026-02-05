(*
    base24 Ciapre
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 7196, 10023}
        set foreground color to {38807, 36751, 29555}

        -- Set ANSI Colors
        set ANSI black color to {6168, 7196, 10023}
        set ANSI red color to {32896, 0, 2313}
        set ANSI green color to {18504, 20817, 15163}
        set ANSI yellow color to {12079, 38807, 50886}
        set ANSI blue color to {22102, 28013, 35980}
        set ANSI magenta color to {29298, 19532, 31868}
        set ANSI cyan color to {23387, 20303, 19018}
        set ANSI white color to {38807, 36751, 29555}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27499, 26728, 24415}
        set ANSI bright red color to {43947, 14392, 13364}
        set ANSI bright green color to {42662, 42662, 23901}
        set ANSI bright yellow color to {56540, 57054, 31611}
        set ANSI bright blue color to {12079, 38807, 50886}
        set ANSI bright magenta color to {54227, 12336, 24672}
        set ANSI bright cyan color to {62451, 56026, 45489}
        set ANSI bright white color to {62451, 62451, 62451}
    end tell
end tell
