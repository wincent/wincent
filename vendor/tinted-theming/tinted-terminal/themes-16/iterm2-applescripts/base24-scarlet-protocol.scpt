(*
    base24 Scarlet Protocol
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 5397, 15420}
        set foreground color to {44975, 44975, 44975}

        -- Set ANSI Colors
        set ANSI black color to {6939, 5397, 15420}
        set ANSI red color to {65535, 0, 20817}
        set ANSI green color to {0, 56540, 33924}
        set ANSI yellow color to {26728, 29041, 65535}
        set ANSI blue color to {514, 29041, 46774}
        set ANSI magenta color to {51657, 12336, 51143}
        set ANSI cyan color to {0, 50629, 51143}
        set ANSI white color to {44975, 44975, 44975}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32639, 32639, 32639}
        set ANSI bright red color to {65535, 28013, 26471}
        set ANSI bright green color to {24415, 63993, 26471}
        set ANSI bright yellow color to {65278, 64507, 26471}
        set ANSI bright blue color to {26728, 29041, 65535}
        set ANSI bright magenta color to {48316, 13621, 60395}
        set ANSI bright cyan color to {24415, 65021, 65535}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
