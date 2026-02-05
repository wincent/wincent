(*
    base24 Wild Cherry
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7967, 5654, 9766}
        set foreground color to {49087, 57825, 55512}

        -- Set ANSI Colors
        set ANSI black color to {7967, 5654, 9766}
        set ANSI red color to {55769, 16448, 34181}
        set ANSI green color to {10794, 45746, 20560}
        set ANSI yellow color to {12079, 35723, 47545}
        set ANSI blue color to {34952, 15420, 56540}
        set ANSI magenta color to {60652, 60652, 60652}
        set ANSI cyan color to {49601, 47288, 47031}
        set ANSI white color to {49087, 57825, 55512}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16191, 46003, 52942}
        set ANSI bright red color to {56026, 27499, 43947}
        set ANSI bright green color to {62708, 56283, 42405}
        set ANSI bright yellow color to {60138, 49344, 26214}
        set ANSI bright blue color to {12079, 35723, 47545}
        set ANSI bright magenta color to {44718, 25443, 27499}
        set ANSI bright cyan color to {65535, 37265, 40349}
        set ANSI bright white color to {58596, 33667, 36237}
    end tell
end tell
