(*
    base24 Bluloco Light
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63479, 63479, 63479}
        set foreground color to {14392, 14392, 14906}

        -- Set ANSI Colors
        set ANSI black color to {63479, 63479, 63479}
        set ANSI red color to {51400, 3341, 16705}
        set ANSI green color to {8224, 34952, 14649}
        set ANSI yellow color to {4112, 34181, 55769}
        set ANSI blue color to {7453, 17476, 56797}
        set ANSI magenta color to {28013, 6939, 60909}
        set ANSI cyan color to {7710, 19789, 31354}
        set ANSI white color to {14392, 14392, 14906}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {42662, 42919, 44718}
        set ANSI bright red color to {64507, 18761, 28013}
        set ANSI bright green color to {13364, 45746, 21331}
        set ANSI bright yellow color to {47031, 37779, 9766}
        set ANSI bright blue color to {4112, 34181, 55769}
        set ANSI bright magenta color to {49344, 3084, 45746}
        set ANSI bright cyan color to {23130, 32639, 44204}
        set ANSI bright white color to {7196, 7453, 8481}
    end tell
end tell
