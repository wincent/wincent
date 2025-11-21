(*
    base16 Blueish
    Scheme author: Ben Mayoras
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 9252, 12336}
        set foreground color to {51400, 57825, 63736}

        -- Set ANSI Colors
        set ANSI black color to {9252, 15420, 21588}
        set ANSI red color to {19532, 58853, 34695}
        set ANSI green color to {50115, 59624, 36237}
        set ANSI yellow color to {63222, 52685, 23644}
        set ANSI blue color to {33410, 43690, 65535}
        set ANSI magenta color to {65535, 33924, 56797}
        set ANSI cyan color to {24415, 53713, 65535}
        set ANSI white color to {56797, 60138, 63222}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17990, 10537, 2570}
        set ANSI bright red color to {19532, 58853, 34695}
        set ANSI bright green color to {50115, 59624, 36237}
        set ANSI bright yellow color to {63222, 52685, 23644}
        set ANSI bright blue color to {33410, 43690, 65535}
        set ANSI bright magenta color to {65535, 33924, 56797}
        set ANSI bright cyan color to {24415, 53713, 65535}
        set ANSI bright white color to {36751, 39064, 41120}
    end tell
end tell
