(*
    base24 Eldritch
    Scheme author: https://github.com/eldritch-theme
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8995, 14135}
        set foreground color to {60395, 64250, 64250}

        -- Set ANSI Colors
        set ANSI black color to {8481, 8995, 14135}
        set ANSI red color to {61937, 27756, 30069}
        set ANSI green color to {14135, 62708, 39321}
        set ANSI yellow color to {61937, 64764, 31097}
        set ANSI blue color to {14649, 56797, 65021}
        set ANSI magenta color to {42148, 35980, 62194}
        set ANSI cyan color to {1028, 53713, 63993}
        set ANSI white color to {60395, 64250, 64250}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28784, 33153, 53456}
        set ANSI bright red color to {63736, 39578, 40349}
        set ANSI bright green color to {28527, 65535, 49601}
        set ANSI bright yellow color to {63993, 59881, 41377}
        set ANSI bright blue color to {31354, 59881, 65535}
        set ANSI bright magenta color to {54484, 46003, 65535}
        set ANSI bright cyan color to {27756, 59881, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
