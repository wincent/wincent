(*
    tinted8 Catppuccin Mocha
    Scheme author: https://github.com/catppuccin/catppuccin
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 7710, 11822}
        set foreground color to {52685, 54998, 62708}

        -- Set ANSI Colors
        set ANSI black color to {7710, 7710, 11822}
        set ANSI red color to {62451, 35723, 43176}
        set ANSI green color to {42662, 58339, 41377}
        set ANSI yellow color to {63993, 58082, 44975}
        set ANSI blue color to {35209, 46260, 64250}
        set ANSI magenta color to {52171, 42662, 63479}
        set ANSI cyan color to {38036, 58082, 54741}
        set ANSI white color to {52685, 54998, 62708}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13621, 13621, 21588}
        set ANSI bright red color to {63993, 49858, 53970}
        set ANSI bright green color to {54227, 61937, 53456}
        set ANSI bright yellow color to {64764, 63222, 59881}
        set ANSI bright blue color to {50372, 55769, 64764}
        set ANSI bright magenta color to {60652, 57568, 64507}
        set ANSI bright cyan color to {50372, 61423, 59624}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
