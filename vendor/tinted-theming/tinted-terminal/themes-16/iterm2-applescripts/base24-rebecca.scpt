(*
    base24 Rebecca
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10537, 10794, 17476}
        set foreground color to {50115, 50115, 54484}

        -- Set ANSI Colors
        set ANSI black color to {10537, 10794, 17476}
        set ANSI red color to {56797, 30326, 21845}
        set ANSI green color to {1028, 56283, 46260}
        set ANSI yellow color to {26985, 49087, 64250}
        set ANSI blue color to {31354, 42405, 65535}
        set ANSI magenta color to {48830, 39835, 63736}
        set ANSI cyan color to {22102, 54227, 49601}
        set ANSI white color to {50115, 50115, 54484}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {34181, 34181, 44204}
        set ANSI bright red color to {65535, 37265, 52685}
        set ANSI bright green color to {0, 59881, 49344}
        set ANSI bright yellow color to {65278, 64764, 43176}
        set ANSI bright blue color to {26985, 49087, 64250}
        set ANSI bright magenta color to {49344, 32639, 63736}
        set ANSI bright cyan color to {35723, 64764, 57825}
        set ANSI bright white color to {62451, 62194, 63736}
    end tell
end tell
