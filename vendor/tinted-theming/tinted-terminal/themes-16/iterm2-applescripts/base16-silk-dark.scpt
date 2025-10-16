(*
    base16 Silk Dark
    Scheme author: Gabriel Fontes (https://github.com/Misterio77)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3598, 15420, 17990}
        set foreground color to {51143, 56283, 56797}

        -- Set ANSI Colors
        set ANSI black color to {7453, 18761, 20046}
        set ANSI red color to {64507, 26985, 21331}
        set ANSI green color to {29555, 55512, 44461}
        set ANSI yellow color to {64764, 58339, 32896}
        set ANSI blue color to {17990, 48573, 56797}
        set ANSI magenta color to {30069, 27499, 35466}
        set ANSI cyan color to {16191, 45746, 47545}
        set ANSI white color to {52171, 62194, 63479}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {10794, 20560, 21588}
        set ANSI bright red color to {64507, 26985, 21331}
        set ANSI bright green color to {29555, 55512, 44461}
        set ANSI bright yellow color to {64764, 58339, 32896}
        set ANSI bright blue color to {17990, 48573, 56797}
        set ANSI bright magenta color to {30069, 27499, 35466}
        set ANSI bright cyan color to {16191, 45746, 47545}
        set ANSI bright white color to {53970, 64250, 65535}
    end tell
end tell
