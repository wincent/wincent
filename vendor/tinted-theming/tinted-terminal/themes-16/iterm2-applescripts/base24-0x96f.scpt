(*
    base24 0x96f
    Scheme author: Filip Janevski (https://0x96f.dev/theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 9252, 10023}
        set foreground color to {64764, 64764, 64764}

        -- Set ANSI Colors
        set ANSI black color to {9766, 9252, 10023}
        set ANSI red color to {65535, 29298, 29298}
        set ANSI green color to {48316, 57311, 22873}
        set ANSI yellow color to {65535, 51914, 22616}
        set ANSI blue color to {18761, 51914, 58596}
        set ANSI magenta color to {41120, 37779, 58082}
        set ANSI cyan color to {44718, 59624, 62708}
        set ANSI white color to {64764, 64764, 64764}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26471, 25957, 26471}
        set ANSI bright red color to {65535, 34695, 34695}
        set ANSI bright green color to {50886, 58596, 29298}
        set ANSI bright yellow color to {65535, 53970, 29041}
        set ANSI bright blue color to {25700, 53970, 59624}
        set ANSI bright magenta color to {44718, 41891, 59110}
        set ANSI bright cyan color to {47802, 60395, 63222}
        set ANSI bright white color to {64764, 64764, 64764}
    end tell
end tell
