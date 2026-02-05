(*
    base16 Primer Light
    Scheme author: Jimmy Lin
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64250, 64507, 64764}
        set foreground color to {12079, 13878, 15677}

        -- Set ANSI Colors
        set ANSI black color to {64250, 64507, 64764}
        set ANSI red color to {55255, 14906, 18761}
        set ANSI green color to {10280, 42919, 17733}
        set ANSI yellow color to {65535, 54227, 15677}
        set ANSI blue color to {771, 26214, 54998}
        set ANSI magenta color to {60138, 19018, 43690}
        set ANSI cyan color to {31097, 47288, 65535}
        set ANSI white color to {12079, 13878, 15677}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {38293, 40349, 42405}
        set ANSI bright red color to {55255, 14906, 18761}
        set ANSI bright green color to {10280, 42919, 17733}
        set ANSI bright yellow color to {65535, 54227, 15677}
        set ANSI bright blue color to {771, 26214, 54998}
        set ANSI bright magenta color to {60138, 19018, 43690}
        set ANSI bright cyan color to {31097, 47288, 65535}
        set ANSI bright white color to {6939, 7967, 8995}
    end tell
end tell
