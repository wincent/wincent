(*
    base24 Laser
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {771, 3341, 6168}
        set foreground color to {55512, 55512, 55512}

        -- Set ANSI Colors
        set ANSI black color to {24929, 24929, 24929}
        set ANSI red color to {65535, 33410, 29298}
        set ANSI green color to {46260, 64250, 29298}
        set ANSI yellow color to {63993, 10280, 33667}
        set ANSI blue color to {65278, 54227, 0}
        set ANSI magenta color to {65535, 36751, 65021}
        set ANSI cyan color to {53456, 53713, 65278}
        set ANSI white color to {61937, 61937, 61937}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {36494, 36494, 36494}
        set ANSI bright red color to {65535, 50372, 48573}
        set ANSI bright green color to {54998, 64764, 47545}
        set ANSI bright yellow color to {65278, 65021, 54741}
        set ANSI bright blue color to {63993, 10280, 33667}
        set ANSI bright magenta color to {65535, 45489, 65278}
        set ANSI bright cyan color to {58853, 59110, 65278}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
