(*
    base24 Lumina Quartz Light Contrast
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65021, 65021, 65278}
        set foreground color to {3598, 3855, 4883}

        -- Set ANSI Colors
        set ANSI black color to {65021, 65021, 65278}
        set ANSI red color to {26214, 0, 1285}
        set ANSI green color to {0, 22616, 7967}
        set ANSI yellow color to {32382, 18504, 0}
        set ANSI blue color to {0, 19275, 31354}
        set ANSI magenta color to {28013, 15420, 39064}
        set ANSI cyan color to {0, 21588, 25443}
        set ANSI white color to {3598, 3855, 4883}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {56026, 56026, 56540}
        set ANSI bright red color to {18247, 257, 771}
        set ANSI bright green color to {0, 16962, 5397}
        set ANSI bright yellow color to {25700, 14392, 0}
        set ANSI bright blue color to {0, 14392, 23901}
        set ANSI bright magenta color to {23387, 3855, 22616}
        set ANSI bright cyan color to {0, 16448, 19275}
        set ANSI bright white color to {3598, 3855, 4883}
    end tell
end tell
