(*
    base16 0x96f
    Scheme author: Filip Janevski (https://0x96f.dev/theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 9252, 10023}
        set foreground color to {64764, 64764, 64764}

        -- Set ANSI Colors
        set ANSI black color to {15163, 14649, 15420}
        set ANSI red color to {65535, 29298, 29298}
        set ANSI green color to {48316, 57311, 22873}
        set ANSI yellow color to {65535, 51914, 22616}
        set ANSI blue color to {18761, 51914, 58596}
        set ANSI magenta color to {41120, 37779, 58082}
        set ANSI cyan color to {44718, 59624, 62708}
        set ANSI white color to {60138, 59881, 60395}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20817, 20303, 21074}
        set ANSI bright red color to {65535, 29298, 29298}
        set ANSI bright green color to {48316, 57311, 22873}
        set ANSI bright yellow color to {65535, 51914, 22616}
        set ANSI bright blue color to {18761, 51914, 58596}
        set ANSI bright magenta color to {41120, 37779, 58082}
        set ANSI bright cyan color to {44718, 59624, 62708}
        set ANSI bright white color to {64764, 64764, 64764}
    end tell
end tell
