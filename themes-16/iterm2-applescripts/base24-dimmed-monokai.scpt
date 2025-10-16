(*
    base24 Dimmed Monokai
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 7710, 7710}
        set foreground color to {44204, 44975, 44204}

        -- Set ANSI Colors
        set ANSI black color to {14906, 15420, 17219}
        set ANSI red color to {48830, 15934, 18504}
        set ANSI green color to {34438, 39578, 14906}
        set ANSI yellow color to {5911, 27756, 58339}
        set ANSI blue color to {20046, 30326, 41377}
        set ANSI magenta color to {34181, 23387, 36237}
        set ANSI cyan color to {22102, 36494, 41891}
        set ANSI white color to {47288, 48316, 47545}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {34952, 35209, 34695}
        set ANSI bright red color to {64507, 0, 7710}
        set ANSI bright green color to {3598, 29041, 11822}
        set ANSI bright yellow color to {50115, 28784, 13107}
        set ANSI bright blue color to {5911, 27756, 58339}
        set ANSI bright magenta color to {64507, 0, 26471}
        set ANSI bright cyan color to {11565, 28527, 27756}
        set ANSI bright white color to {64764, 65535, 47288}
    end tell
end tell
