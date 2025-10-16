(*
    base16 Hopscotch
    Scheme author: Jan T. Sott
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {12850, 10537, 12593}
        set foreground color to {47545, 46517, 47288}

        -- Set ANSI Colors
        set ANSI black color to {17219, 15163, 16962}
        set ANSI red color to {56797, 17990, 19532}
        set ANSI green color to {36751, 49601, 15934}
        set ANSI yellow color to {65021, 52428, 22873}
        set ANSI blue color to {4626, 37008, 49087}
        set ANSI magenta color to {51400, 24158, 31868}
        set ANSI cyan color to {5140, 39835, 37779}
        set ANSI white color to {54741, 54227, 54741}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23644, 21588, 23387}
        set ANSI bright red color to {56797, 17990, 19532}
        set ANSI bright green color to {36751, 49601, 15934}
        set ANSI bright yellow color to {65021, 52428, 22873}
        set ANSI bright blue color to {4626, 37008, 49087}
        set ANSI bright magenta color to {51400, 24158, 31868}
        set ANSI bright cyan color to {5140, 39835, 37779}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
