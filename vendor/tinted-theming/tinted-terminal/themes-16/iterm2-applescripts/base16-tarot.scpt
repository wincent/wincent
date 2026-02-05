(*
    base16 tarot
    Scheme author: ed (https://codeberg.org/ed)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3598, 2313, 7453}
        set foreground color to {43690, 21845, 28527}

        -- Set ANSI Colors
        set ANSI black color to {3598, 2313, 7453}
        set ANSI red color to {50629, 12850, 21331}
        set ANSI green color to {42662, 36494, 23130}
        set ANSI yellow color to {65535, 25957, 25957}
        set ANSI blue color to {28270, 24672, 32896}
        set ANSI magenta color to {42148, 22359, 33410}
        set ANSI cyan color to {35980, 38807, 34181}
        set ANSI white color to {43690, 21845, 28527}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29812, 12593, 27499}
        set ANSI bright red color to {50629, 12850, 21331}
        set ANSI bright green color to {42662, 36494, 23130}
        set ANSI bright yellow color to {65535, 25957, 25957}
        set ANSI bright blue color to {28270, 24672, 32896}
        set ANSI bright magenta color to {42148, 22359, 33410}
        set ANSI bright cyan color to {35980, 38807, 34181}
        set ANSI bright white color to {56540, 36751, 31868}
    end tell
end tell
