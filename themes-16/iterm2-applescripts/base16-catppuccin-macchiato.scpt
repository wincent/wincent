(*
    base16 Catppuccin Macchiato
    Scheme author: https://github.com/catppuccin/catppuccin
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 10023, 14906}
        set foreground color to {51914, 54227, 62965}

        -- Set ANSI Colors
        set ANSI black color to {7710, 8224, 12336}
        set ANSI red color to {60909, 34695, 38550}
        set ANSI green color to {42662, 56026, 38293}
        set ANSI yellow color to {61166, 54484, 40863}
        set ANSI blue color to {35466, 44461, 62708}
        set ANSI magenta color to {50886, 41120, 63222}
        set ANSI cyan color to {35723, 54741, 51914}
        set ANSI white color to {62708, 56283, 54998}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13878, 14906, 20303}
        set ANSI bright red color to {60909, 34695, 38550}
        set ANSI bright green color to {42662, 56026, 38293}
        set ANSI bright yellow color to {61166, 54484, 40863}
        set ANSI bright blue color to {35466, 44461, 62708}
        set ANSI bright magenta color to {50886, 41120, 63222}
        set ANSI bright cyan color to {35723, 54741, 51914}
        set ANSI bright white color to {47031, 48573, 63736}
    end tell
end tell
