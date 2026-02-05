(*
    base24 Argonaut
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 3855, 6168}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {3341, 3855, 6168}
        set ANSI red color to {65535, 0, 3855}
        set ANSI green color to {35980, 57568, 2570}
        set ANSI yellow color to {0, 37522, 65535}
        set ANSI blue color to {0, 36237, 63736}
        set ANSI magenta color to {27756, 17219, 42405}
        set ANSI cyan color to {0, 55255, 60395}
        set ANSI white color to {53456, 53456, 53456}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29298, 29298, 29298}
        set ANSI bright red color to {65535, 10023, 16191}
        set ANSI bright green color to {43947, 57568, 23130}
        set ANSI bright yellow color to {65535, 53713, 16705}
        set ANSI bright blue color to {0, 37522, 65535}
        set ANSI bright magenta color to {39578, 24415, 60395}
        set ANSI bright cyan color to {26471, 65535, 61423}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
