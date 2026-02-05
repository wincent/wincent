(*
    base24 Breeze
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {12593, 13878, 15163}
        set foreground color to {54227, 55255, 55512}

        -- Set ANSI Colors
        set ANSI black color to {12593, 13878, 15163}
        set ANSI red color to {60909, 5397, 5397}
        set ANSI green color to {4369, 53713, 5654}
        set ANSI yellow color to {15677, 44718, 59881}
        set ANSI blue color to {7453, 39321, 62451}
        set ANSI magenta color to {39835, 22873, 46774}
        set ANSI cyan color to {6682, 48316, 40092}
        set ANSI white color to {54227, 55255, 55512}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {39835, 42405, 42662}
        set ANSI bright red color to {49344, 14649, 11051}
        set ANSI bright green color to {7196, 56540, 39578}
        set ANSI bright yellow color to {65021, 48316, 19275}
        set ANSI bright blue color to {15677, 44718, 59881}
        set ANSI bright magenta color to {36494, 17476, 44461}
        set ANSI bright cyan color to {5654, 41120, 34181}
        set ANSI bright white color to {64764, 64764, 64764}
    end tell
end tell
