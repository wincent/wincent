(*
    base24 Lumina Dusk Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 6168, 9509}
        set foreground color to {57568, 56540, 60138}

        -- Set ANSI Colors
        set ANSI black color to {6682, 6168, 9509}
        set ANSI red color to {53456, 29812, 27756}
        set ANSI green color to {41120, 53713, 43433}
        set ANSI yellow color to {61423, 52171, 31611}
        set ANSI blue color to {39835, 48830, 62194}
        set ANSI magenta color to {49601, 48059, 61680}
        set ANSI cyan color to {37008, 53199, 55255}
        set ANSI white color to {57568, 56540, 60138}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12850, 12336, 16448}
        set ANSI bright red color to {57054, 38293, 36237}
        set ANSI bright green color to {47545, 60652, 49858}
        set ANSI bright yellow color to {65535, 58853, 44461}
        set ANSI bright blue color to {48573, 55512, 65535}
        set ANSI bright magenta color to {64764, 51657, 63479}
        set ANSI bright cyan color to {43433, 59881, 62194}
        set ANSI bright white color to {57568, 56540, 60138}
    end tell
end tell
