(*
    base24 Lumina Rayleigh Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {60909, 63736, 65535}
        set foreground color to {7453, 12079, 18247}

        -- Set ANSI Colors
        set ANSI black color to {60909, 63736, 65535}
        set ANSI red color to {38036, 5911, 6939}
        set ANSI green color to {7710, 30583, 15163}
        set ANSI yellow color to {41891, 24415, 0}
        set ANSI blue color to {257, 24672, 42919}
        set ANSI magenta color to {29298, 17476, 43433}
        set ANSI cyan color to {1285, 25186, 29041}
        set ANSI white color to {7453, 12079, 18247}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {51400, 54998, 57311}
        set ANSI bright red color to {27756, 7967, 7453}
        set ANSI bright green color to {257, 25186, 10794}
        set ANSI bright yellow color to {34695, 20046, 0}
        set ANSI bright blue color to {0, 19532, 34695}
        set ANSI bright magenta color to {30326, 12593, 29041}
        set ANSI bright cyan color to {0, 19789, 22873}
        set ANSI bright white color to {7453, 12079, 18247}
    end tell
end tell
