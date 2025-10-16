(*
    base16 Chinoiserie Morandi
    Scheme author: Di Wang (https://cs.cmu.edu/~diw3)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 7453, 7453}
        set foreground color to {50372, 52171, 53199}

        -- Set ANSI Colors
        set ANSI black color to {10280, 10280, 10280}
        set ANSI red color to {49344, 24672, 24929}
        set ANSI green color to {35980, 41120, 31611}
        set ANSI yellow color to {58853, 48316, 33924}
        set ANSI blue color to {33667, 40606, 51657}
        set ANSI magenta color to {39064, 41377, 55512}
        set ANSI cyan color to {24158, 35980, 39835}
        set ANSI white color to {61166, 59367, 62194}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14135, 14135, 14135}
        set ANSI bright red color to {49344, 24672, 24929}
        set ANSI bright green color to {35980, 41120, 31611}
        set ANSI bright yellow color to {58853, 48316, 33924}
        set ANSI bright blue color to {33667, 40606, 51657}
        set ANSI bright magenta color to {39064, 41377, 55512}
        set ANSI bright cyan color to {24158, 35980, 39835}
        set ANSI bright white color to {65535, 65278, 63993}
    end tell
end tell
