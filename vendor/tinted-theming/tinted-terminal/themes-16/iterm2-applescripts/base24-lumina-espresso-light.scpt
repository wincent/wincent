(*
    base24 Lumina Espresso Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64764, 61680, 58339}
        set foreground color to {14649, 9766, 6939}

        -- Set ANSI Colors
        set ANSI black color to {64764, 61680, 58339}
        set ANSI red color to {33924, 8481, 8224}
        set ANSI green color to {5397, 29812, 19789}
        set ANSI yellow color to {28013, 20046, 13878}
        set ANSI blue color to {10280, 26728, 41891}
        set ANSI magenta color to {28784, 18761, 41377}
        set ANSI cyan color to {0, 28784, 33667}
        set ANSI white color to {14649, 9766, 6939}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {55769, 52942, 49858}
        set ANSI bright red color to {24415, 8224, 7710}
        set ANSI bright green color to {0, 24158, 15420}
        set ANSI bright yellow color to {25957, 13364, 0}
        set ANSI bright blue color to {6682, 21588, 34952}
        set ANSI bright magenta color to {28784, 14392, 27499}
        set ANSI bright cyan color to {0, 23130, 27242}
        set ANSI bright white color to {14649, 9766, 6939}
    end tell
end tell
