(*
    base16 Equilibrium Gray Dark
    Scheme author: Carlo Abelli
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4369, 4369, 4369}
        set foreground color to {43947, 43947, 43947}

        -- Set ANSI Colors
        set ANSI black color to {6939, 6939, 6939}
        set ANSI red color to {61680, 17219, 14649}
        set ANSI green color to {32639, 35723, 0}
        set ANSI yellow color to {48059, 34952, 257}
        set ANSI blue color to {0, 36237, 53713}
        set ANSI magenta color to {27242, 32639, 53970}
        set ANSI cyan color to {0, 38036, 35723}
        set ANSI white color to {50886, 50886, 50886}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {9766, 9766, 9766}
        set ANSI bright red color to {61680, 17219, 14649}
        set ANSI bright green color to {32639, 35723, 0}
        set ANSI bright yellow color to {48059, 34952, 257}
        set ANSI bright blue color to {0, 36237, 53713}
        set ANSI bright magenta color to {27242, 32639, 53970}
        set ANSI bright cyan color to {0, 38036, 35723}
        set ANSI bright white color to {58082, 58082, 58082}
    end tell
end tell
