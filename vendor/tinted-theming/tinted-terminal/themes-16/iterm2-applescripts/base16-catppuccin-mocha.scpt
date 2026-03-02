(*
    base16 Catppuccin Mocha
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
        set ANSI bright black color to {17733, 18247, 23130}
        set ANSI bright red color to {62451, 35723, 43176}
        set ANSI bright green color to {42662, 58339, 41377}
        set ANSI bright yellow color to {63993, 58082, 44975}
        set ANSI bright blue color to {35209, 46260, 64250}
        set ANSI bright magenta color to {52171, 42662, 63479}
        set ANSI bright cyan color to {38036, 58082, 54741}
        set ANSI bright white color to {46260, 48830, 65278}
    end tell
end tell
