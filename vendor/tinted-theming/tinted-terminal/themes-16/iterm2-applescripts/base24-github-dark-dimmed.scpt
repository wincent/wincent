(*
    base24 Github Dark Dimmed
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 4369, 5911}
        set foreground color to {53713, 55255, 57568}

        -- Set ANSI Colors
        set ANSI black color to {3341, 4369, 5911}
        set ANSI red color to {62708, 28784, 26471}
        set ANSI green color to {22359, 43947, 23130}
        set ANSI yellow color to {50886, 37008, 9766}
        set ANSI blue color to {21331, 39835, 62965}
        set ANSI magenta color to {45232, 33667, 61680}
        set ANSI cyan color to {14649, 50629, 53199}
        set ANSI white color to {53713, 55255, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25957, 27756, 30326}
        set ANSI bright red color to {65535, 37779, 35466}
        set ANSI bright green color to {27499, 50372, 28013}
        set ANSI bright yellow color to {56026, 43690, 16191}
        set ANSI bright blue color to {27756, 46774, 65535}
        set ANSI bright magenta color to {56540, 48573, 64507}
        set ANSI bright cyan color to {22102, 54484, 56797}
        set ANSI bright white color to {52685, 55769, 58853}
    end tell
end tell
