(*
    base16 Embers Light
    Scheme author: Jannik Siebert (https://github.com/janniks)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {53713, 54998, 56283}
        set foreground color to {12850, 15163, 17219}

        -- Set ANSI Colors
        set ANSI black color to {44718, 46774, 48830}
        set ANSI red color to {22359, 28013, 33410}
        set ANSI green color to {28013, 33410, 22359}
        set ANSI yellow color to {22359, 33410, 28013}
        set ANSI blue color to {33410, 22359, 28013}
        set ANSI magenta color to {28013, 22359, 33410}
        set ANSI cyan color to {33410, 28013, 22359}
        set ANSI white color to {8224, 9766, 11308}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {37008, 39578, 41891}
        set ANSI bright red color to {22359, 28013, 33410}
        set ANSI bright green color to {28013, 33410, 22359}
        set ANSI bright yellow color to {22359, 33410, 28013}
        set ANSI bright blue color to {33410, 22359, 28013}
        set ANSI bright magenta color to {28013, 22359, 33410}
        set ANSI bright cyan color to {33410, 28013, 22359}
        set ANSI bright white color to {3855, 4883, 5654}
    end tell
end tell
