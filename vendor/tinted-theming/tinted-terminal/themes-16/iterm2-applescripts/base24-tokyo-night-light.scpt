(*
    base24 Tokyo Night Light
    Scheme author: Michaël Ball, based on Tokyo Night by enkia (https://github.com/enkia/tokyo-night-vscode-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {54741, 54998, 56283}
        set foreground color to {13364, 15163, 22873}

        -- Set ANSI Colors
        set ANSI black color to {52171, 52428, 53713}
        set ANSI red color to {13364, 15163, 22873}
        set ANSI green color to {18504, 24158, 12336}
        set ANSI yellow color to {5654, 26471, 30069}
        set ANSI blue color to {13364, 21588, 35466}
        set ANSI magenta color to {23130, 19018, 30840}
        set ANSI cyan color to {15934, 26985, 26728}
        set ANSI white color to {6682, 6939, 9766}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {57311, 57568, 58853}
        set ANSI bright red color to {35980, 17219, 20817}
        set ANSI bright green color to {18504, 24158, 12336}
        set ANSI bright yellow color to {38550, 20560, 10023}
        set ANSI bright blue color to {13364, 21588, 35466}
        set ANSI bright magenta color to {23130, 19018, 30840}
        set ANSI bright cyan color to {15934, 26985, 26728}
        set ANSI bright white color to {6682, 6939, 9766}
    end tell
end tell
