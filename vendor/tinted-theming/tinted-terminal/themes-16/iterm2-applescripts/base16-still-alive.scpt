(*
    base16 Still Alive
    Scheme author: Derrick McKee (derrick.mckee@gmail.com), Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61680, 61680, 61680}
        set foreground color to {19532, 14392, 15163}

        -- Set ANSI Colors
        set ANSI black color to {54998, 54998, 54998}
        set ANSI red color to {55512, 0, 0}
        set ANSI green color to {12336, 43176, 24672}
        set ANSI yellow color to {65535, 61680, 6168}
        set ANSI blue color to {13878, 24158, 65535}
        set ANSI magenta color to {37008, 13878, 65535}
        set ANSI cyan color to {13878, 54227, 65535}
        set ANSI white color to {13107, 7967, 8481}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {48573, 48573, 48573}
        set ANSI bright red color to {55512, 0, 0}
        set ANSI bright green color to {12336, 43176, 24672}
        set ANSI bright yellow color to {65535, 61680, 6168}
        set ANSI bright blue color to {13878, 24158, 65535}
        set ANSI bright magenta color to {37008, 13878, 65535}
        set ANSI bright cyan color to {13878, 54227, 65535}
        set ANSI bright white color to {5140, 3084, 3341}
    end tell
end tell
