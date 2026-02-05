(*
    base16 eris
    Scheme author: ed (https://codeberg.org/ed), Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2570, 2313, 8224}
        set foreground color to {24672, 27499, 44204}

        -- Set ANSI Colors
        set ANSI black color to {2570, 2313, 8224}
        set ANSI red color to {63479, 26728, 41891}
        set ANSI green color to {41634, 64250, 43176}
        set ANSI yellow color to {63479, 54998, 26728}
        set ANSI blue color to {9509, 36751, 50372}
        set ANSI magenta color to {50115, 26728, 63479}
        set ANSI cyan color to {41634, 64250, 61680}
        set ANSI white color to {24672, 27499, 44204}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13107, 14135, 29555}
        set ANSI bright red color to {63479, 26728, 41891}
        set ANSI bright green color to {41634, 64250, 43176}
        set ANSI bright yellow color to {63479, 54998, 26728}
        set ANSI bright blue color to {9509, 36751, 50372}
        set ANSI bright magenta color to {50115, 26728, 63479}
        set ANSI bright cyan color to {41634, 64250, 61680}
        set ANSI bright white color to {39578, 43690, 58853}
    end tell
end tell
