(*
    base16 selenized-light
    Scheme author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64507, 62451, 56283}
        set foreground color to {21331, 26471, 28013}

        -- Set ANSI Colors
        set ANSI black color to {60652, 58339, 52428}
        set ANSI red color to {52428, 5911, 10537}
        set ANSI green color to {16962, 35723, 0}
        set ANSI yellow color to {42919, 33667, 0}
        set ANSI blue color to {0, 28013, 52942}
        set ANSI magenta color to {33410, 23901, 49344}
        set ANSI cyan color to {0, 38807, 35466}
        set ANSI white color to {14906, 19789, 21331}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {54741, 52685, 46774}
        set ANSI bright red color to {52428, 5911, 10537}
        set ANSI bright green color to {16962, 35723, 0}
        set ANSI bright yellow color to {42919, 33667, 0}
        set ANSI bright blue color to {0, 28013, 52942}
        set ANSI bright magenta color to {33410, 23901, 49344}
        set ANSI bright cyan color to {0, 38807, 35466}
        set ANSI bright white color to {14906, 19789, 21331}
    end tell
end tell
