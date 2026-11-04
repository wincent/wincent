(*
    base24 Lumina Harbor Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64507, 62965, 60652}
        set foreground color to {7196, 11565, 20303}

        -- Set ANSI Colors
        set ANSI black color to {64507, 62965, 60652}
        set ANSI red color to {35980, 7196, 7453}
        set ANSI green color to {6425, 30840, 19789}
        set ANSI yellow color to {41634, 24415, 1542}
        set ANSI blue color to {1028, 26728, 42148}
        set ANSI magenta color to {26471, 22616, 43176}
        set ANSI cyan color to {1028, 26728, 29041}
        set ANSI white color to {7196, 11565, 20303}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {56026, 53970, 50886}
        set ANSI bright red color to {25957, 7967, 7453}
        set ANSI bright green color to {0, 25186, 15420}
        set ANSI bright yellow color to {34695, 20046, 0}
        set ANSI bright blue color to {0, 21588, 34438}
        set ANSI bright magenta color to {29041, 15163, 32125}
        set ANSI bright cyan color to {0, 21331, 23130}
        set ANSI bright white color to {7196, 11565, 20303}
    end tell
end tell
