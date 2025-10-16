(*
    base24 Blue Matrix
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3855, 4369, 5397}
        set foreground color to {44975, 44975, 44975}

        -- Set ANSI Colors
        set ANSI black color to {4112, 4369, 5654}
        set ANSI red color to {65535, 22102, 32639}
        set ANSI green color to {0, 65535, 39835}
        set ANSI yellow color to {26728, 29041, 65535}
        set ANSI blue color to {0, 45232, 65278}
        set ANSI magenta color to {54484, 31611, 65278}
        set ANSI cyan color to {30069, 49601, 65278}
        set ANSI white color to {51143, 51143, 51143}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26471, 26471, 26471}
        set ANSI bright red color to {65535, 28013, 26471}
        set ANSI bright green color to {24415, 63993, 26471}
        set ANSI bright yellow color to {65278, 64507, 26471}
        set ANSI bright blue color to {26728, 29041, 65535}
        set ANSI bright magenta color to {54741, 33410, 60395}
        set ANSI bright cyan color to {24415, 65021, 65535}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
