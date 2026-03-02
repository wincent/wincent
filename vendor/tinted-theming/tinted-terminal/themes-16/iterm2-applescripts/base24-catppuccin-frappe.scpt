(*
    base24 Catppuccin Frappe
    Scheme author: https://github.com/catppuccin/catppuccin
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {12336, 13364, 17990}
        set foreground color to {50886, 53456, 62965}

        -- Set ANSI Colors
        set ANSI black color to {12336, 13364, 17990}
        set ANSI red color to {59367, 33410, 33924}
        set ANSI green color to {42662, 53713, 35209}
        set ANSI yellow color to {58853, 51400, 37008}
        set ANSI blue color to {35980, 43690, 61166}
        set ANSI magenta color to {51914, 40606, 59110}
        set ANSI cyan color to {33153, 51400, 48830}
        set ANSI white color to {50886, 53456, 62965}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20817, 22359, 28013}
        set ANSI bright red color to {60138, 39321, 40092}
        set ANSI bright green color to {42662, 53713, 35209}
        set ANSI bright yellow color to {62194, 54741, 53199}
        set ANSI bright blue color to {34181, 49601, 56540}
        set ANSI bright magenta color to {62708, 47288, 58596}
        set ANSI bright cyan color to {39321, 53713, 56283}
        set ANSI bright white color to {47802, 48059, 61937}
    end tell
end tell
