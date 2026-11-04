(*
    base24 Lumina Lagoon Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {59881, 64250, 64250}
        set foreground color to {2827, 12850, 15163}

        -- Set ANSI Colors
        set ANSI black color to {59881, 64250, 64250}
        set ANSI red color to {36751, 8481, 8481}
        set ANSI green color to {11822, 24929, 18247}
        set ANSI yellow color to {41377, 24672, 3341}
        set ANSI blue color to {6168, 23644, 43433}
        set ANSI magenta color to {29041, 21331, 46517}
        set ANSI cyan color to {0, 28270, 29041}
        set ANSI white color to {2827, 12850, 15163}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {50629, 55512, 55512}
        set ANSI bright red color to {26728, 8738, 8224}
        set ANSI bright green color to {0, 20560, 12593}
        set ANSI bright yellow color to {34695, 20046, 0}
        set ANSI bright blue color to {5397, 18761, 34438}
        set ANSI bright magenta color to {29298, 13878, 28270}
        set ANSI bright cyan color to {0, 22616, 23387}
        set ANSI bright white color to {2827, 12850, 15163}
    end tell
end tell
