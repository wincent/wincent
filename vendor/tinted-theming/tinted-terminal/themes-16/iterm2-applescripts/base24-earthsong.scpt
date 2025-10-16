(*
    base24 Earthsong
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 9252, 8224}
        set foreground color to {50629, 43947, 37779}

        -- Set ANSI Colors
        set ANSI black color to {4369, 5140, 5911}
        set ANSI red color to {51400, 16705, 13364}
        set ANSI green color to {33924, 50372, 19275}
        set ANSI yellow color to {24158, 55769, 65535}
        set ANSI blue color to {4883, 38807, 47545}
        set ANSI magenta color to {53456, 25186, 15420}
        set ANSI cyan color to {20303, 38036, 21074}
        set ANSI white color to {58853, 50629, 43433}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 24158, 21588}
        set ANSI bright red color to {65535, 25700, 22873}
        set ANSI bright green color to {38807, 57568, 13621}
        set ANSI bright yellow color to {57311, 54741, 24929}
        set ANSI bright blue color to {24158, 55769, 65535}
        set ANSI bright magenta color to {65535, 37265, 26728}
        set ANSI bright cyan color to {33667, 61423, 34952}
        set ANSI bright white color to {63222, 63222, 60652}
    end tell
end tell
