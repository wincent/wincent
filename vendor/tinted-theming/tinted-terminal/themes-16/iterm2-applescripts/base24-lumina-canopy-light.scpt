(*
    base24 Lumina Canopy Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61937, 63993, 61423}
        set foreground color to {7710, 13107, 8995}

        -- Set ANSI Colors
        set ANSI black color to {61937, 63993, 61423}
        set ANSI red color to {34438, 3084, 11308}
        set ANSI green color to {13107, 30069, 17733}
        set ANSI yellow color to {37008, 22359, 1285}
        set ANSI blue color to {1028, 27242, 42919}
        set ANSI magenta color to {25957, 22873, 40606}
        set ANSI cyan color to {0, 29041, 33924}
        set ANSI white color to {7710, 13107, 8995}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {52685, 55255, 52171}
        set ANSI bright red color to {23387, 7453, 9766}
        set ANSI bright green color to {8224, 24672, 13107}
        set ANSI bright yellow color to {30326, 17990, 0}
        set ANSI bright blue color to {3598, 22102, 34438}
        set ANSI bright magenta color to {28784, 14649, 27756}
        set ANSI bright cyan color to {0, 23387, 27499}
        set ANSI bright white color to {7710, 13107, 8995}
    end tell
end tell
