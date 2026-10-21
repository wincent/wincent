(*
    base24 Madrid
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64250, 64250, 64250}
        set foreground color to {6682, 6682, 6682}

        -- Set ANSI Colors
        set ANSI black color to {64250, 64250, 64250}
        set ANSI red color to {39321, 0, 9766}
        set ANSI green color to {0, 31354, 10280}
        set ANSI yellow color to {35466, 25700, 2056}
        set ANSI blue color to {0, 31354, 40606}
        set ANSI magenta color to {19789, 9766, 39321}
        set ANSI cyan color to {0, 31354, 40606}
        set ANSI white color to {6682, 6682, 6682}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {19789, 19789, 19789}
        set ANSI bright red color to {39321, 0, 9766}
        set ANSI bright green color to {0, 31354, 10280}
        set ANSI bright yellow color to {35466, 25700, 2056}
        set ANSI bright blue color to {0, 31354, 40606}
        set ANSI bright magenta color to {19789, 9766, 39321}
        set ANSI bright cyan color to {0, 31354, 40606}
        set ANSI bright white color to {6682, 6682, 6682}
    end tell
end tell
