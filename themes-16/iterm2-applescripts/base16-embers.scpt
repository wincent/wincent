(*
    base16 Embers
    Scheme author: Jannik Siebert (https://github.com/janniks)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 4883, 3855}
        set foreground color to {41891, 39578, 37008}

        -- Set ANSI Colors
        set ANSI black color to {11308, 9766, 8224}
        set ANSI red color to {33410, 28013, 22359}
        set ANSI green color to {22359, 33410, 28013}
        set ANSI yellow color to {28013, 33410, 22359}
        set ANSI blue color to {28013, 22359, 33410}
        set ANSI magenta color to {33410, 22359, 28013}
        set ANSI cyan color to {22359, 28013, 33410}
        set ANSI white color to {48830, 46774, 44718}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17219, 15163, 12850}
        set ANSI bright red color to {33410, 28013, 22359}
        set ANSI bright green color to {22359, 33410, 28013}
        set ANSI bright yellow color to {28013, 33410, 22359}
        set ANSI bright blue color to {28013, 22359, 33410}
        set ANSI bright magenta color to {33410, 22359, 28013}
        set ANSI bright cyan color to {22359, 28013, 33410}
        set ANSI bright white color to {56283, 54998, 53713}
    end tell
end tell
