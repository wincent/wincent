(*
    base16 Tokyo City Terminal Light
    Scheme author: Michaël Ball
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64507, 64507, 65021}
        set foreground color to {10280, 12850, 14906}

        -- Set ANSI Colors
        set ANSI black color to {64507, 64507, 65021}
        set ANSI red color to {35980, 17219, 20817}
        set ANSI green color to {13107, 25443, 23644}
        set ANSI yellow color to {36751, 24158, 5397}
        set ANSI blue color to {13364, 21588, 35466}
        set ANSI magenta color to {23130, 19018, 30840}
        set ANSI cyan color to {3855, 19275, 28270}
        set ANSI white color to {10280, 12850, 14906}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {47031, 50629, 54227}
        set ANSI bright red color to {35980, 17219, 20817}
        set ANSI bright green color to {13107, 25443, 23644}
        set ANSI bright yellow color to {36751, 24158, 5397}
        set ANSI bright blue color to {13364, 21588, 35466}
        set ANSI bright magenta color to {23130, 19018, 30840}
        set ANSI bright cyan color to {3855, 19275, 28270}
        set ANSI bright white color to {5911, 7453, 8995}
    end tell
end tell
