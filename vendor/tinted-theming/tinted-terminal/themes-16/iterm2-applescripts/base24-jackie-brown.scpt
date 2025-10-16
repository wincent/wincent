(*
    base24 Jackie Brown
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11308, 7196, 5397}
        set foreground color to {43176, 43176, 43176}

        -- Set ANSI Colors
        set ANSI black color to {11308, 7453, 5654}
        set ANSI red color to {61423, 22359, 13364}
        set ANSI green color to {11051, 44975, 11051}
        set ANSI yellow color to {0, 0, 65535}
        set ANSI blue color to {9252, 28013, 45746}
        set ANSI magenta color to {53199, 24158, 49344}
        set ANSI cyan color to {0, 44204, 61166}
        set ANSI white color to {49087, 49087, 49087}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 26214, 26214}
        set ANSI bright red color to {58853, 0, 0}
        set ANSI bright green color to {34438, 43176, 15934}
        set ANSI bright yellow color to {58853, 58853, 0}
        set ANSI bright blue color to {0, 0, 65535}
        set ANSI bright magenta color to {58853, 0, 58853}
        set ANSI bright cyan color to {0, 58853, 58853}
        set ANSI bright white color to {58853, 58853, 58853}
    end tell
end tell
