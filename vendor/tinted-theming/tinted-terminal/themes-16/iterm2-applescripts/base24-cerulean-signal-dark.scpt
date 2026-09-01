(*
    base24 Cerulean Signal Dark
    Scheme author: Aaron Colichia (https://aaron.colichia.org/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 5911, 8738}
        set foreground color to {56540, 59110, 62194}

        -- Set ANSI Colors
        set ANSI black color to {4112, 5911, 8738}
        set ANSI red color to {65535, 35466, 39578}
        set ANSI green color to {28784, 57825, 45232}
        set ANSI yellow color to {58082, 51400, 24415}
        set ANSI blue color to {32125, 54227, 65535}
        set ANSI magenta color to {65535, 29812, 54484}
        set ANSI cyan color to {22616, 55769, 57311}
        set ANSI white color to {56540, 59110, 62194}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {36751, 41120, 46517}
        set ANSI bright red color to {65535, 40092, 44204}
        set ANSI bright green color to {35723, 59367, 48573}
        set ANSI bright yellow color to {62708, 56540, 30326}
        set ANSI bright blue color to {39578, 57311, 65535}
        set ANSI bright magenta color to {65535, 35723, 56797}
        set ANSI bright cyan color to {29298, 59367, 60395}
        set ANSI bright white color to {63479, 63993, 64764}
    end tell
end tell
