(*
    base24 Flatland
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 7710, 8224}
        set foreground color to {50629, 50886, 50372}

        -- Set ANSI Colors
        set ANSI black color to {7196, 7453, 6425}
        set ANSI red color to {61937, 33410, 14392}
        set ANSI green color to {40606, 53970, 25700}
        set ANSI yellow color to {24929, 47288, 53456}
        set ANSI blue color to {20303, 38550, 48830}
        set ANSI magenta color to {26985, 23130, 48059}
        set ANSI cyan color to {54741, 14392, 25700}
        set ANSI white color to {65278, 65535, 65278}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {7196, 7453, 6425}
        set ANSI bright red color to {53713, 10794, 9252}
        set ANSI bright green color to {42919, 54227, 11308}
        set ANSI bright yellow color to {65535, 35209, 18504}
        set ANSI bright blue color to {24929, 47288, 53456}
        set ANSI bright magenta color to {26985, 23130, 48059}
        set ANSI bright cyan color to {54741, 14392, 25700}
        set ANSI bright white color to {65278, 65535, 65278}
    end tell
end tell
