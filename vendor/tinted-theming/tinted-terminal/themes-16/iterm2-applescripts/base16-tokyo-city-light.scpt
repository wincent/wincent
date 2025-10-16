(*
    base16 Tokyo City Light
    Scheme author: Michaël Ball
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64507, 64507, 65021}
        set foreground color to {13364, 15163, 22873}

        -- Set ANSI Colors
        set ANSI black color to {63222, 63222, 63736}
        set ANSI red color to {35980, 17219, 20817}
        set ANSI green color to {18504, 24158, 12336}
        set ANSI yellow color to {19532, 20560, 24158}
        set ANSI blue color to {13364, 21588, 35466}
        set ANSI magenta color to {23130, 19018, 30840}
        set ANSI cyan color to {19532, 20560, 24158}
        set ANSI white color to {7453, 9509, 11308}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {60909, 61423, 63222}
        set ANSI bright red color to {35980, 17219, 20817}
        set ANSI bright green color to {18504, 24158, 12336}
        set ANSI bright yellow color to {19532, 20560, 24158}
        set ANSI bright blue color to {13364, 21588, 35466}
        set ANSI bright magenta color to {23130, 19018, 30840}
        set ANSI bright cyan color to {19532, 20560, 24158}
        set ANSI bright white color to {5911, 7453, 8995}
    end tell
end tell
