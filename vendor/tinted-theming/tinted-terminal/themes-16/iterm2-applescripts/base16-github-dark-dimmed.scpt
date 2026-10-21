(*
    base16 Github Dark Dimmed
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
        set ANSI bright red color to {62708, 28784, 26471}
        set ANSI bright green color to {22359, 43947, 23130}
        set ANSI bright yellow color to {50886, 37008, 9766}
        set ANSI bright blue color to {21331, 39835, 62965}
        set ANSI bright magenta color to {45232, 33667, 61680}
        set ANSI bright cyan color to {14649, 50629, 53199}
        set ANSI bright white color to {52685, 55769, 58853}
    end tell
end tell
