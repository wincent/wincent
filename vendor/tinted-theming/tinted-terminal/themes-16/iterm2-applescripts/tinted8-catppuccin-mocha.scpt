(*
    tinted8 Catppuccin Mocha
    Scheme author: https://github.com/catppuccin/catppuccin
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 11822, 11822}
        set foreground color to {52685, 62708, 62708}

        -- Set ANSI Colors
        set ANSI black color to {7710, 11822, 11822}
        set ANSI red color to {62451, 43176, 43176}
        set ANSI green color to {42662, 41377, 41377}
        set ANSI yellow color to {63993, 44975, 44975}
        set ANSI blue color to {35209, 64250, 64250}
        set ANSI magenta color to {52171, 63479, 63479}
        set ANSI cyan color to {38036, 54741, 54741}
        set ANSI white color to {52685, 62708, 62708}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13621, 21588, 21588}
        set ANSI bright red color to {63993, 53970, 53970}
        set ANSI bright green color to {54227, 53456, 53456}
        set ANSI bright yellow color to {64764, 59881, 59881}
        set ANSI bright blue color to {50372, 64764, 64764}
        set ANSI bright magenta color to {60652, 64507, 64507}
        set ANSI bright cyan color to {50372, 59624, 59624}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
