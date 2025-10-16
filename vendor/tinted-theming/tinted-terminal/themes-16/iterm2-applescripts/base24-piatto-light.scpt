(*
    base24 Piatto Light
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {53199, 53199, 53199}

        -- Set ANSI Colors
        set ANSI black color to {16705, 16705, 16705}
        set ANSI red color to {45746, 14135, 29041}
        set ANSI green color to {26214, 30840, 7710}
        set ANSI yellow color to {15420, 24158, 43176}
        set ANSI blue color to {15420, 24158, 43176}
        set ANSI magenta color to {42148, 21588, 45746}
        set ANSI cyan color to {26214, 30840, 7710}
        set ANSI white color to {65535, 65535, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16191, 16191, 16191}
        set ANSI bright red color to {56283, 13107, 25957}
        set ANSI bright green color to {33410, 38036, 10537}
        set ANSI bright yellow color to {52685, 28527, 13364}
        set ANSI bright blue color to {15420, 24158, 43176}
        set ANSI bright magenta color to {42148, 21588, 45746}
        set ANSI bright cyan color to {33410, 38036, 10537}
        set ANSI bright white color to {62194, 62194, 62194}
    end tell
end tell
