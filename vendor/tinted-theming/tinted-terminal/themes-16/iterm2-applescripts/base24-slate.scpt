(*
    base24 Slate
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8481, 8481}
        set foreground color to {16962, 54227, 59624}

        -- Set ANSI Colors
        set ANSI black color to {8481, 8481, 8481}
        set ANSI red color to {57825, 42919, 49087}
        set ANSI green color to {32896, 55255, 30840}
        set ANSI yellow color to {31097, 44975, 53970}
        set ANSI blue color to {9509, 19018, 18761}
        set ANSI magenta color to {41891, 32896, 54227}
        set ANSI cyan color to {5140, 43947, 40092}
        set ANSI white color to {16962, 54227, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {49344, 61937, 63736}
        set ANSI bright red color to {65535, 52428, 55512}
        set ANSI bright green color to {48573, 65535, 43176}
        set ANSI bright yellow color to {53456, 52171, 51657}
        set ANSI bright blue color to {31097, 44975, 53970}
        set ANSI bright magenta color to {50372, 42919, 55512}
        set ANSI bright cyan color to {35723, 57054, 57568}
        set ANSI bright white color to {57568, 57568, 57568}
    end tell
end tell
