(*
    base24 Royal
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 2056, 5140}
        set foreground color to {18761, 16962, 23130}

        -- Set ANSI Colors
        set ANSI black color to {9252, 7967, 10794}
        set ANSI red color to {37008, 10023, 19275}
        set ANSI green color to {8995, 32896, 7196}
        set ANSI yellow color to {36751, 47545, 63993}
        set ANSI blue color to {25700, 32896, 44975}
        set ANSI magenta color to {26214, 19789, 38550}
        set ANSI cyan color to {35466, 43690, 48573}
        set ANSI white color to {20817, 18761, 25957}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12593, 11565, 15420}
        set ANSI bright red color to {54484, 13364, 27756}
        set ANSI bright green color to {11308, 55512, 17733}
        set ANSI bright yellow color to {65021, 59624, 14906}
        set ANSI bright blue color to {36751, 47545, 63993}
        set ANSI bright magenta color to {42148, 31097, 58082}
        set ANSI bright cyan color to {43947, 54227, 60395}
        set ANSI bright white color to {40349, 35723, 48573}
    end tell
end tell
