(*
    base24 Tango Half Adapted
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65278, 65278}
        set foreground color to {50886, 51914, 49601}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 0, 0}
        set ANSI green color to {19532, 50115, 0}
        set ANSI yellow color to {30069, 48830, 65535}
        set ANSI blue color to {0, 36237, 62965}
        set ANSI magenta color to {43176, 27499, 45746}
        set ANSI cyan color to {0, 48573, 50115}
        set ANSI white color to {57568, 58596, 56283}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31097, 31868, 30069}
        set ANSI bright red color to {65535, 0, 4626}
        set ANSI bright green color to {35466, 63222, 0}
        set ANSI bright yellow color to {65535, 60395, 0}
        set ANSI bright blue color to {30069, 48830, 65535}
        set ANSI bright magenta color to {55255, 39064, 53456}
        set ANSI bright cyan color to {0, 63222, 64250}
        set ANSI bright white color to {62451, 62451, 61937}
    end tell
end tell
