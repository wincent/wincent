(*
    base16 Helsinki
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63736, 64250, 65278}
        set foreground color to {21588, 19789, 16448}

        -- Set ANSI Colors
        set ANSI black color to {63736, 64250, 65278}
        set ANSI red color to {7967, 43690, 40606}
        set ANSI green color to {29555, 15677, 39578}
        set ANSI yellow color to {11822, 28784, 44461}
        set ANSI blue color to {46517, 23130, 3855}
        set ANSI magenta color to {15934, 40349, 8481}
        set ANSI cyan color to {48573, 19532, 15677}
        set ANSI white color to {21588, 19789, 16448}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {45232, 43433, 39321}
        set ANSI bright red color to {7967, 43690, 40606}
        set ANSI bright green color to {29555, 15677, 39578}
        set ANSI bright yellow color to {11822, 28784, 44461}
        set ANSI bright blue color to {46517, 23130, 3855}
        set ANSI bright magenta color to {15934, 40349, 8481}
        set ANSI bright cyan color to {48573, 19532, 15677}
        set ANSI bright white color to {0, 0, 0}
    end tell
end tell
