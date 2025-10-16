(*
    base16 Codeschool
    Scheme author: blockloop
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8995, 11308, 12593}
        set foreground color to {40606, 42919, 42662}

        -- Set ANSI Colors
        set ANSI black color to {7196, 13878, 22359}
        set ANSI red color to {10794, 21588, 37265}
        set ANSI green color to {8995, 31097, 34438}
        set ANSI yellow color to {41120, 15163, 7710}
        set ANSI blue color to {18504, 19789, 31097}
        set ANSI magenta color to {50629, 39064, 8224}
        set ANSI cyan color to {45232, 12079, 12336}
        set ANSI white color to {42919, 53199, 41891}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {10794, 13364, 14906}
        set ANSI bright red color to {10794, 21588, 37265}
        set ANSI bright green color to {8995, 31097, 34438}
        set ANSI bright yellow color to {41120, 15163, 7710}
        set ANSI bright blue color to {18504, 19789, 31097}
        set ANSI bright magenta color to {50629, 39064, 8224}
        set ANSI bright cyan color to {45232, 12079, 12336}
        set ANSI bright white color to {46517, 55512, 63222}
    end tell
end tell
