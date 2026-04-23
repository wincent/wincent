(*
    tinted8 Catppuccin Latte
    Scheme author: https://github.com/catppuccin/catppuccin
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {56540, 59624, 59624}
        set foreground color to {19532, 26985, 26985}

        -- Set ANSI Colors
        set ANSI black color to {19532, 26985, 26985}
        set ANSI red color to {53970, 14649, 14649}
        set ANSI green color to {16448, 11051, 11051}
        set ANSI yellow color to {57311, 7453, 7453}
        set ANSI blue color to {7710, 62965, 62965}
        set ANSI magenta color to {34952, 61423, 61423}
        set ANSI cyan color to {5911, 39321, 39321}
        set ANSI white color to {56540, 59624, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27756, 34181, 34181}
        set ANSI bright red color to {63736, 21331, 21331}
        set ANSI bright green color to {21331, 14392, 14392}
        set ANSI bright yellow color to {61166, 19275, 19275}
        set ANSI bright blue color to {22873, 63736, 63736}
        set ANSI bright magenta color to {43690, 62708, 62708}
        set ANSI bright cyan color to {6168, 54741, 54741}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
