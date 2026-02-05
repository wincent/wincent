(*
    base16 Apathy
    Scheme author: Jannik Siebert (https://github.com/janniks)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {771, 6682, 5654}
        set foreground color to {33153, 46517, 44204}

        -- Set ANSI Colors
        set ANSI black color to {771, 6682, 5654}
        set ANSI red color to {15934, 38550, 34952}
        set ANSI green color to {34952, 15934, 38550}
        set ANSI yellow color to {15934, 19532, 38550}
        set ANSI blue color to {38550, 34952, 15934}
        set ANSI magenta color to {19532, 38550, 15934}
        set ANSI cyan color to {38550, 15934, 19532}
        set ANSI white color to {33153, 46517, 44204}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {11051, 26728, 24158}
        set ANSI bright red color to {15934, 38550, 34952}
        set ANSI bright green color to {34952, 15934, 38550}
        set ANSI bright yellow color to {15934, 19532, 38550}
        set ANSI bright blue color to {38550, 34952, 15934}
        set ANSI bright magenta color to {19532, 38550, 15934}
        set ANSI bright cyan color to {38550, 15934, 19532}
        set ANSI bright white color to {53970, 59367, 58596}
    end tell
end tell
