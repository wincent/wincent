(*
    base24 Treehouse
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 6425, 6425}
        set foreground color to {26985, 23901, 18247}

        -- Set ANSI Colors
        set ANSI black color to {12850, 4626, 0}
        set ANSI red color to {45489, 10023, 3598}
        set ANSI green color to {17476, 43433, 0}
        set ANSI yellow color to {34181, 53199, 60652}
        set ANSI blue color to {22359, 33924, 39321}
        set ANSI magenta color to {38550, 13878, 15420}
        set ANSI cyan color to {45746, 22873, 7453}
        set ANSI white color to {30583, 27499, 21331}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16962, 13878, 9509}
        set ANSI bright red color to {60909, 23644, 8224}
        set ANSI bright green color to {21845, 62194, 14135}
        set ANSI bright yellow color to {61937, 47031, 12593}
        set ANSI bright blue color to {34181, 53199, 60652}
        set ANSI bright magenta color to {57568, 19275, 23130}
        set ANSI bright cyan color to {61680, 32125, 5140}
        set ANSI bright white color to {65535, 51400, 0}
    end tell
end tell
