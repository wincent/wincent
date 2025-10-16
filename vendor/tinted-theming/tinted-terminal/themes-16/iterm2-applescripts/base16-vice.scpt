(*
    base16 vice
    Scheme author: Thomas Leon Highbaugh thighbaugh@zoho.com
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5911, 6425, 7710}
        set foreground color to {35723, 40092, 48830}

        -- Set ANSI Colors
        set ANSI black color to {8738, 9766, 11565}
        set ANSI red color to {65535, 10537, 43176}
        set ANSI green color to {2827, 44461, 65535}
        set ANSI yellow color to {61680, 65535, 43690}
        set ANSI blue color to {0, 60138, 65535}
        set ANSI magenta color to {0, 63222, 55769}
        set ANSI cyan color to {33410, 25957, 65535}
        set ANSI white color to {45746, 49087, 55769}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15420, 16191, 19532}
        set ANSI bright red color to {65535, 10537, 43176}
        set ANSI bright green color to {2827, 44461, 65535}
        set ANSI bright yellow color to {61680, 65535, 43690}
        set ANSI bright blue color to {0, 60138, 65535}
        set ANSI bright magenta color to {0, 63222, 55769}
        set ANSI bright cyan color to {33410, 25957, 65535}
        set ANSI bright white color to {62708, 62708, 63479}
    end tell
end tell
