(*
    base16 Heetch Light
    Scheme author: Geoffrey Teale (tealeg@gmail.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65278, 65535, 65535}
        set foreground color to {23130, 18761, 28270}

        -- Set ANSI Colors
        set ANSI black color to {14649, 9509, 20817}
        set ANSI red color to {10023, 55769, 54741}
        set ANSI green color to {63736, 0, 22873}
        set ANSI yellow color to {23387, 41634, 46774}
        set ANSI blue color to {18247, 63993, 62965}
        set ANSI magenta color to {48573, 257, 21074}
        set ANSI cyan color to {50115, 13878, 30840}
        set ANSI white color to {18247, 1285, 17990}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31611, 28013, 35723}
        set ANSI bright red color to {10023, 55769, 54741}
        set ANSI bright green color to {63736, 0, 22873}
        set ANSI bright yellow color to {23387, 41634, 46774}
        set ANSI bright blue color to {18247, 63993, 62965}
        set ANSI bright magenta color to {48573, 257, 21074}
        set ANSI bright cyan color to {50115, 13878, 30840}
        set ANSI bright white color to {6425, 257, 13364}
    end tell
end tell
