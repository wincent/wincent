(*
    base24 Japanesque
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 7453, 7453}
        set foreground color to {53456, 53970, 52942}

        -- Set ANSI Colors
        set ANSI black color to {7453, 7453, 7453}
        set ANSI red color to {52942, 15934, 24672}
        set ANSI green color to {31611, 47031, 23387}
        set ANSI yellow color to {4883, 22616, 31097}
        set ANSI blue color to {19532, 39321, 54227}
        set ANSI magenta color to {42405, 32639, 50372}
        set ANSI cyan color to {14392, 39578, 44204}
        set ANSI white color to {53456, 53970, 52942}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32896, 33410, 32639}
        set ANSI bright red color to {53713, 36494, 42662}
        set ANSI bright green color to {30326, 32382, 11051}
        set ANSI bright yellow color to {30583, 22873, 11822}
        set ANSI bright blue color to {4883, 22616, 31097}
        set ANSI bright magenta color to {24415, 16705, 37008}
        set ANSI bright cyan color to {30326, 48059, 51914}
        set ANSI bright white color to {45489, 46517, 44718}
    end tell
end tell
