(*
    base24 Arthur
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 7196, 7196}
        set foreground color to {41377, 37008, 33667}

        -- Set ANSI Colors
        set ANSI black color to {7196, 7196, 7196}
        set ANSI red color to {52685, 23644, 23644}
        set ANSI green color to {34438, 44975, 32896}
        set ANSI yellow color to {34695, 52942, 60395}
        set ANSI blue color to {25700, 38293, 60909}
        set ANSI magenta color to {57054, 47288, 34695}
        set ANSI cyan color to {45232, 50372, 57054}
        set ANSI white color to {41377, 37008, 33667}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 23901, 22873}
        set ANSI bright red color to {52428, 21845, 13107}
        set ANSI bright green color to {34952, 43690, 8738}
        set ANSI bright yellow color to {65535, 42919, 23901}
        set ANSI bright blue color to {34695, 52942, 60395}
        set ANSI bright magenta color to {39321, 26214, 0}
        set ANSI bright cyan color to {45232, 50372, 57054}
        set ANSI bright white color to {56797, 52428, 48059}
    end tell
end tell
