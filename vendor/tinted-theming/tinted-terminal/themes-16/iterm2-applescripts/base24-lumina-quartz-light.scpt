(*
    base24 Lumina Quartz Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62965, 63479, 64250}
        set foreground color to {12336, 13621, 15163}

        -- Set ANSI Colors
        set ANSI black color to {62965, 63479, 64250}
        set ANSI red color to {32125, 11051, 10280}
        set ANSI green color to {8481, 30069, 20560}
        set ANSI yellow color to {39578, 25700, 11308}
        set ANSI blue color to {17476, 26728, 38036}
        set ANSI magenta color to {30326, 21331, 42405}
        set ANSI cyan color to {0, 28784, 37522}
        set ANSI white color to {12336, 13621, 15163}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {53970, 54484, 55769}
        set ANSI bright red color to {23130, 9509, 8738}
        set ANSI bright green color to {8481, 24158, 16705}
        set ANSI bright yellow color to {33410, 20817, 7196}
        set ANSI bright blue color to {12593, 21588, 32382}
        set ANSI bright magenta color to {27756, 16191, 26985}
        set ANSI bright cyan color to {4369, 23130, 29812}
        set ANSI bright white color to {12336, 13621, 15163}
    end tell
end tell
