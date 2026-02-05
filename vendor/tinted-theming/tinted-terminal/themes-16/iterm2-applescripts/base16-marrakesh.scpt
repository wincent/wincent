(*
    base16 Marrakesh
    Scheme author: Alexandre Gavioli (http://github.com/Alexx2/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 5654, 514}
        set foreground color to {38036, 36494, 18504}

        -- Set ANSI Colors
        set ANSI black color to {8224, 5654, 514}
        set ANSI red color to {50115, 21331, 22873}
        set ANSI green color to {6168, 38807, 20046}
        set ANSI yellow color to {43176, 33667, 14649}
        set ANSI blue color to {18247, 31868, 41377}
        set ANSI magenta color to {34952, 26728, 46003}
        set ANSI cyan color to {30069, 42919, 14392}
        set ANSI white color to {38036, 36494, 18504}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27756, 26728, 8995}
        set ANSI bright red color to {50115, 21331, 22873}
        set ANSI bright green color to {6168, 38807, 20046}
        set ANSI bright yellow color to {43176, 33667, 14649}
        set ANSI bright blue color to {18247, 31868, 41377}
        set ANSI bright magenta color to {34952, 26728, 46003}
        set ANSI bright cyan color to {30069, 42919, 14392}
        set ANSI bright white color to {64250, 61680, 42405}
    end tell
end tell
