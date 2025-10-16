(*
    base16 Linux VT
    Scheme author: j-c-m (https://github.com/j-c-m/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {43690, 43690, 43690}

        -- Set ANSI Colors
        set ANSI black color to {13107, 13107, 13107}
        set ANSI red color to {43690, 0, 0}
        set ANSI green color to {0, 43690, 0}
        set ANSI yellow color to {65535, 65535, 21845}
        set ANSI blue color to {21845, 21845, 65535}
        set ANSI magenta color to {65535, 21845, 65535}
        set ANSI cyan color to {0, 43690, 43690}
        set ANSI white color to {52428, 52428, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17476, 17476, 17476}
        set ANSI bright red color to {43690, 0, 0}
        set ANSI bright green color to {0, 43690, 0}
        set ANSI bright yellow color to {65535, 65535, 21845}
        set ANSI bright blue color to {21845, 21845, 65535}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {0, 43690, 43690}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
