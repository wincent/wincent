(*
    base16 Catppuccin Latte
    Scheme author: https://github.com/catppuccin/catppuccin
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61423, 61937, 62965}
        set foreground color to {19532, 20303, 26985}

        -- Set ANSI Colors
        set ANSI black color to {61423, 61937, 62965}
        set ANSI red color to {53970, 3855, 14649}
        set ANSI green color to {16448, 41120, 11051}
        set ANSI yellow color to {57311, 36494, 7453}
        set ANSI blue color to {7710, 26214, 62965}
        set ANSI magenta color to {34952, 14649, 61423}
        set ANSI cyan color to {5911, 37522, 39321}
        set ANSI white color to {19532, 20303, 26985}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {40092, 41120, 45232}
        set ANSI bright red color to {53970, 3855, 14649}
        set ANSI bright green color to {16448, 41120, 11051}
        set ANSI bright yellow color to {57311, 36494, 7453}
        set ANSI bright blue color to {7710, 26214, 62965}
        set ANSI bright magenta color to {34952, 14649, 61423}
        set ANSI bright cyan color to {5911, 37522, 39321}
        set ANSI bright white color to {29298, 34695, 65021}
    end tell
end tell
