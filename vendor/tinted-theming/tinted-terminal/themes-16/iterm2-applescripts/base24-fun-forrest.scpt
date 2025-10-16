(*
    base24 Fun Forrest
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 4626, 0}
        set foreground color to {50629, 43947, 24672}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {54741, 9509, 11051}
        set ANSI green color to {37008, 39835, 0}
        set ANSI yellow color to {31868, 51657, 52942}
        set ANSI blue color to {17990, 39064, 41634}
        set ANSI magenta color to {35980, 16962, 12593}
        set ANSI cyan color to {55769, 33153, 4626}
        set ANSI white color to {56797, 49601, 25957}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32382, 26985, 21588}
        set ANSI bright red color to {58596, 22873, 6939}
        set ANSI bright green color to {49087, 50886, 22873}
        set ANSI bright yellow color to {65535, 51914, 6939}
        set ANSI bright blue color to {31868, 51657, 52942}
        set ANSI bright magenta color to {53713, 25443, 18761}
        set ANSI bright cyan color to {59110, 43433, 27499}
        set ANSI bright white color to {65535, 59881, 41891}
    end tell
end tell
