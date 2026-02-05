(*
    base24 Crayon Pony Fish
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5140, 1542, 1799}
        set foreground color to {23901, 18504, 20046}

        -- Set ANSI Colors
        set ANSI black color to {5140, 1542, 1799}
        set ANSI red color to {37008, 0, 10794}
        set ANSI green color to {22359, 38293, 8995}
        set ANSI yellow color to {53199, 51657, 65535}
        set ANSI blue color to {35723, 34695, 44975}
        set ANSI magenta color to {26728, 11822, 20560}
        set ANSI cyan color to {59624, 42919, 26214}
        set ANSI white color to {23901, 18504, 20046}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18247, 13364, 14392}
        set ANSI bright red color to {50629, 9252, 23644}
        set ANSI bright green color to {36237, 65535, 22102}
        set ANSI bright yellow color to {51143, 14135, 7453}
        set ANSI bright blue color to {53199, 51657, 65535}
        set ANSI bright magenta color to {64507, 27756, 47545}
        set ANSI bright cyan color to {65535, 52942, 44718}
        set ANSI bright white color to {44975, 38036, 40349}
    end tell
end tell
