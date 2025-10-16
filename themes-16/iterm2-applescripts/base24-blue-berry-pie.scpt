(*
    base24 Blue Berry Pie
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 2827, 10280}
        set foreground color to {48059, 45746, 44461}

        -- Set ANSI Colors
        set ANSI black color to {2570, 19275, 24929}
        set ANSI red color to {39321, 8995, 28013}
        set ANSI green color to {23387, 45232, 45746}
        set ANSI yellow color to {14392, 5654, 15677}
        set ANSI blue color to {37008, 42405, 48316}
        set ANSI magenta color to {40349, 21331, 42919}
        set ANSI cyan color to {32382, 33410, 52428}
        set ANSI white color to {61680, 59367, 54741}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {7967, 5654, 14135}
        set ANSI bright red color to {51143, 29041, 29041}
        set ANSI bright green color to {2570, 27499, 32382}
        set ANSI bright yellow color to {31097, 12593, 34952}
        set ANSI bright blue color to {14392, 5654, 15677}
        set ANSI bright magenta color to {48316, 37779, 46774}
        set ANSI bright cyan color to {23901, 24415, 29041}
        set ANSI bright white color to {2570, 27499, 32382}
    end tell
end tell
