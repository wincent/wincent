(*
    base24 Cyberdyne
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5397, 4369, 17476}
        set foreground color to {49344, 49344, 49344}

        -- Set ANSI Colors
        set ANSI black color to {5397, 4369, 17476}
        set ANSI red color to {65535, 33410, 29298}
        set ANSI green color to {0, 49601, 29298}
        set ANSI yellow color to {49601, 58339, 65278}
        set ANSI blue color to {0, 29041, 53199}
        set ANSI magenta color to {65535, 36751, 65021}
        set ANSI cyan color to {27499, 65535, 56540}
        set ANSI white color to {49344, 49344, 49344}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24158, 24158, 24158}
        set ANSI bright red color to {65535, 50372, 48573}
        set ANSI bright green color to {54998, 64764, 47545}
        set ANSI bright yellow color to {65278, 65021, 54741}
        set ANSI bright blue color to {49601, 58339, 65278}
        set ANSI bright magenta color to {65535, 45489, 65278}
        set ANSI bright cyan color to {58853, 59110, 65278}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
