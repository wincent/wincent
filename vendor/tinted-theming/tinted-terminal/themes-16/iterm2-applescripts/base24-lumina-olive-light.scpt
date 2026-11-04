(*
    base24 Lumina Olive Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63479, 63222, 58853}
        set foreground color to {12336, 11822, 5654}

        -- Set ANSI Colors
        set ANSI black color to {63479, 63222, 58853}
        set ANSI red color to {35466, 7967, 7967}
        set ANSI green color to {12336, 25186, 20046}
        set ANSI yellow color to {41377, 24672, 4112}
        set ANSI blue color to {12850, 25700, 41891}
        set ANSI magenta color to {25443, 21845, 41120}
        set ANSI cyan color to {0, 28527, 33667}
        set ANSI white color to {12336, 11822, 5654}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {54484, 54227, 50629}
        set ANSI bright red color to {25700, 8224, 7710}
        set ANSI bright green color to {0, 20817, 14649}
        set ANSI bright yellow color to {34695, 20046, 0}
        set ANSI bright blue color to {7710, 20560, 35980}
        set ANSI bright magenta color to {30326, 14906, 29298}
        set ANSI bright cyan color to {0, 22873, 27242}
        set ANSI bright white color to {12336, 11822, 5654}
    end tell
end tell
