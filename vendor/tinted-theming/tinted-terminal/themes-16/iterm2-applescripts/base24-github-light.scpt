(*
    base24 Github Light
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {60138, 61166, 62194}
        set foreground color to {16962, 19018, 21331}

        -- Set ANSI Colors
        set ANSI black color to {60138, 61166, 62194}
        set ANSI red color to {64250, 17733, 18761}
        set ANSI green color to {11565, 42148, 20046}
        set ANSI yellow color to {49087, 34695, 0}
        set ANSI blue color to {8481, 35723, 65535}
        set ANSI magenta color to {42148, 30069, 63993}
        set ANSI cyan color to {13107, 40349, 39835}
        set ANSI white color to {16962, 19018, 21331}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {35980, 38293, 40863}
        set ANSI bright red color to {65535, 33153, 33410}
        set ANSI bright green color to {19018, 49858, 27499}
        set ANSI bright yellow color to {54484, 42919, 11308}
        set ANSI bright blue color to {21588, 44718, 65535}
        set ANSI bright magenta color to {49858, 38807, 65535}
        set ANSI bright cyan color to {18761, 48316, 47031}
        set ANSI bright white color to {7967, 8995, 10280}
    end tell
end tell
