(*
    base24 Flexoki Light
    Scheme author: Steph Ango (https://github.com/kepano/flexoki)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 64764, 61680}
        set foreground color to {16448, 15934, 15420}

        -- Set ANSI Colors
        set ANSI black color to {62194, 61680, 58853}
        set ANSI red color to {44975, 12336, 10537}
        set ANSI green color to {26214, 32896, 2827}
        set ANSI yellow color to {44461, 33667, 257}
        set ANSI blue color to {8224, 24158, 42662}
        set ANSI magenta color to {24158, 16448, 40349}
        set ANSI cyan color to {9252, 33667, 31611}
        set ANSI white color to {10280, 10023, 9766}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {59110, 58596, 55769}
        set ANSI bright red color to {53713, 19789, 16705}
        set ANSI bright green color to {53456, 41634, 5397}
        set ANSI bright yellow color to {56026, 28784, 11308}
        set ANSI bright blue color to {14906, 43433, 40863}
        set ANSI bright magenta color to {17219, 34181, 48830}
        set ANSI bright cyan color to {34695, 39578, 14649}
        set ANSI bright white color to {4112, 3855, 3855}
    end tell
end tell
