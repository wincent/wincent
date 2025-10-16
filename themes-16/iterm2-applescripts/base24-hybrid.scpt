(*
    base24 Hybrid
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 5911, 6168}
        set foreground color to {36751, 37265, 37008}

        -- Set ANSI Colors
        set ANSI black color to {10794, 11822, 13107}
        set ANSI red color to {47031, 19789, 20560}
        set ANSI green color to {46003, 48830, 23130}
        set ANSI yellow color to {19275, 27499, 34952}
        set ANSI blue color to {28013, 37008, 45232}
        set ANSI magenta color to {41120, 32382, 43947}
        set ANSI cyan color to {32639, 48830, 46003}
        set ANSI white color to {46517, 47288, 46774}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {7453, 7710, 8481}
        set ANSI bright red color to {35980, 11565, 12850}
        set ANSI bright green color to {30840, 33667, 12593}
        set ANSI bright yellow color to {58853, 35209, 20303}
        set ANSI bright blue color to {19275, 27499, 34952}
        set ANSI bright magenta color to {28270, 20303, 31097}
        set ANSI bright cyan color to {19789, 31611, 29555}
        set ANSI bright white color to {23130, 24929, 26985}
    end tell
end tell
