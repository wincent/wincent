(*
    base24 Red Planet
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8738, 8738, 8738}
        set foreground color to {42148, 39321, 35980}

        -- Set ANSI Colors
        set ANSI black color to {8738, 8738, 8738}
        set ANSI red color to {35980, 13364, 12850}
        set ANSI green color to {29298, 33410, 29041}
        set ANSI yellow color to {24672, 33410, 32382}
        set ANSI blue color to {26985, 32896, 40606}
        set ANSI magenta color to {35209, 25700, 37522}
        set ANSI cyan color to {23387, 33667, 37008}
        set ANSI white color to {42148, 39321, 35980}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31611, 30583, 29555}
        set ANSI bright red color to {46517, 21074, 16962}
        set ANSI bright green color to {34438, 39321, 34181}
        set ANSI bright yellow color to {60395, 60395, 37265}
        set ANSI bright blue color to {24672, 33410, 32382}
        set ANSI bright magenta color to {57054, 18504, 29555}
        set ANSI bright cyan color to {14392, 44461, 55512}
        set ANSI bright white color to {54998, 49087, 47288}
    end tell
end tell
