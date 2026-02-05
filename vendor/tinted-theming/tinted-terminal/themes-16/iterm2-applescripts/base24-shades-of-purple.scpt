(*
    base24 Shades Of Purple
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 7453, 16448}
        set foreground color to {44975, 44975, 44975}

        -- Set ANSI Colors
        set ANSI black color to {7710, 7453, 16448}
        set ANSI red color to {55769, 1028, 10537}
        set ANSI green color to {14906, 55769, 0}
        set ANSI yellow color to {26728, 29041, 65535}
        set ANSI blue color to {26985, 17219, 65535}
        set ANSI magenta color to {65535, 11051, 28784}
        set ANSI cyan color to {0, 50629, 51143}
        set ANSI white color to {44975, 44975, 44975}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32639, 32639, 32639}
        set ANSI bright red color to {63993, 10537, 6939}
        set ANSI bright green color to {16962, 54484, 9509}
        set ANSI bright yellow color to {61937, 53456, 0}
        set ANSI bright blue color to {26728, 29041, 65535}
        set ANSI bright magenta color to {65535, 30326, 65535}
        set ANSI bright cyan color to {31097, 59367, 64250}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
