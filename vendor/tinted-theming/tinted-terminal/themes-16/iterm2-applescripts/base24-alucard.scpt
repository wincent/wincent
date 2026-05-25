(*
    base24 Alucard
    Scheme author: clach04 (https://github.com/clach04)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 64507, 60395}
        set foreground color to {7967, 7967, 7967}

        -- Set ANSI Colors
        set ANSI black color to {65535, 64507, 60395}
        set ANSI red color to {52171, 14906, 10794}
        set ANSI green color to {5140, 29041, 2570}
        set ANSI yellow color to {33924, 28270, 5397}
        set ANSI blue color to {25700, 19018, 51657}
        set ANSI magenta color to {41891, 5140, 19789}
        set ANSI cyan color to {771, 27242, 38550}
        set ANSI white color to {7967, 7967, 7967}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27756, 26214, 19275}
        set ANSI bright red color to {55255, 19532, 15677}
        set ANSI bright green color to {6425, 36237, 3084}
        set ANSI bright yellow color to {40606, 33924, 6682}
        set ANSI bright blue color to {30840, 25186, 53456}
        set ANSI bright magenta color to {49087, 6168, 23130}
        set ANSI bright cyan color to {1028, 32639, 46260}
        set ANSI bright white color to {11308, 11051, 12593}
    end tell
end tell
