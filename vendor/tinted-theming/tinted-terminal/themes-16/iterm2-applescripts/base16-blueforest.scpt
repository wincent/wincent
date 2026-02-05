(*
    base16 Blue Forest
    Scheme author: alonsodomin (https://github.com/alonsodomin)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5140, 7967, 11822}
        set foreground color to {65535, 52428, 13107}

        -- Set ANSI Colors
        set ANSI black color to {5140, 7967, 11822}
        set ANSI red color to {65535, 64250, 45489}
        set ANSI green color to {32896, 65535, 32896}
        set ANSI yellow color to {37265, 52428, 65535}
        set ANSI blue color to {41634, 53199, 62965}
        set ANSI magenta color to {0, 39321, 65535}
        set ANSI cyan color to {32896, 65535, 32896}
        set ANSI white color to {65535, 52428, 13107}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {41120, 65535, 41120}
        set ANSI bright red color to {65535, 64250, 45489}
        set ANSI bright green color to {32896, 65535, 32896}
        set ANSI bright yellow color to {37265, 52428, 65535}
        set ANSI bright blue color to {41634, 53199, 62965}
        set ANSI bright magenta color to {0, 39321, 65535}
        set ANSI bright cyan color to {32896, 65535, 32896}
        set ANSI bright white color to {14135, 22359, 32896}
    end tell
end tell
