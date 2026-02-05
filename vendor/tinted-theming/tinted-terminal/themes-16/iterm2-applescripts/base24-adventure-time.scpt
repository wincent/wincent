(*
    base24 Adventure Time
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 7196, 17476}
        set foreground color to {52685, 50115, 49087}

        -- Set ANSI Colors
        set ANSI black color to {7710, 7196, 17476}
        set ANSI red color to {48316, 0, 4883}
        set ANSI green color to {18761, 45489, 5911}
        set ANSI yellow color to {6168, 38550, 50886}
        set ANSI blue color to {3855, 18761, 50886}
        set ANSI magenta color to {26214, 22873, 37522}
        set ANSI cyan color to {28527, 42148, 38807}
        set ANSI white color to {52685, 50115, 49087}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30840, 37779, 49087}
        set ANSI bright red color to {64764, 24158, 22873}
        set ANSI bright green color to {40349, 65535, 28270}
        set ANSI bright yellow color to {61423, 49601, 6682}
        set ANSI bright blue color to {6168, 38550, 50886}
        set ANSI bright magenta color to {39578, 22873, 21074}
        set ANSI bright cyan color to {51400, 63993, 62451}
        set ANSI bright white color to {62965, 62708, 64507}
    end tell
end tell
