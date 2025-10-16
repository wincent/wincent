(*
    base16 Atelier Sulphurpool
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 10023, 17990}
        set foreground color to {38807, 40349, 46260}

        -- Set ANSI Colors
        set ANSI black color to {10537, 12850, 22102}
        set ANSI red color to {51657, 18761, 8738}
        set ANSI green color to {44204, 38807, 14649}
        set ANSI yellow color to {49344, 35723, 12336}
        set ANSI blue color to {15677, 36751, 53713}
        set ANSI magenta color to {26214, 31097, 52428}
        set ANSI cyan color to {8738, 41634, 51657}
        set ANSI white color to {57311, 58082, 61937}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24158, 26214, 34695}
        set ANSI bright red color to {51657, 18761, 8738}
        set ANSI bright green color to {44204, 38807, 14649}
        set ANSI bright yellow color to {49344, 35723, 12336}
        set ANSI bright blue color to {15677, 36751, 53713}
        set ANSI bright magenta color to {26214, 31097, 52428}
        set ANSI bright cyan color to {8738, 41634, 51657}
        set ANSI bright white color to {62965, 63479, 65535}
    end tell
end tell
