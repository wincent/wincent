(*
    base24 Space Gray Eighties Dull
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8481, 8481}
        set foreground color to {39578, 40863, 42662}

        -- Set ANSI Colors
        set ANSI black color to {5397, 5911, 7196}
        set ANSI red color to {45489, 18761, 22102}
        set ANSI green color to {37265, 46003, 30583}
        set ANSI yellow color to {21588, 34181, 49344}
        set ANSI blue color to {31611, 36751, 42148}
        set ANSI magenta color to {42405, 30583, 40606}
        set ANSI cyan color to {32639, 52428, 52171}
        set ANSI white color to {45746, 47288, 49858}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {60652, 24415, 26471}
        set ANSI bright green color to {34952, 59881, 34181}
        set ANSI bright yellow color to {65021, 49858, 21331}
        set ANSI bright blue color to {21588, 34181, 49344}
        set ANSI bright magenta color to {49087, 33667, 49344}
        set ANSI bright cyan color to {22616, 49858, 49344}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
