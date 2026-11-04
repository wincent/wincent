(*
    base24 Lumina Cherenkov Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62965, 63736, 65535}
        set foreground color to {7967, 11822, 21331}

        -- Set ANSI Colors
        set ANSI black color to {62965, 63736, 65535}
        set ANSI red color to {41891, 8738, 9252}
        set ANSI green color to {8738, 31354, 15934}
        set ANSI yellow color to {41891, 24415, 0}
        set ANSI blue color to {2570, 20303, 52428}
        set ANSI magenta color to {30840, 18761, 49601}
        set ANSI cyan color to {2056, 29041, 33153}
        set ANSI white color to {7967, 11822, 21331}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {53713, 54741, 57311}
        set ANSI bright red color to {31097, 10280, 9509}
        set ANSI bright green color to {1799, 25957, 11308}
        set ANSI bright yellow color to {34695, 20046, 0}
        set ANSI bright blue color to {7453, 17476, 36751}
        set ANSI bright magenta color to {31097, 13364, 29812}
        set ANSI bright cyan color to {0, 23644, 26985}
        set ANSI bright white color to {7967, 11822, 21331}
    end tell
end tell
