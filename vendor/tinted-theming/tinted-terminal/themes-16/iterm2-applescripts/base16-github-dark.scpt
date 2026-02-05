(*
    base16 Github Dark
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 6939, 8738}
        set foreground color to {51657, 53713, 55769}

        -- Set ANSI Colors
        set ANSI black color to {5654, 6939, 8738}
        set ANSI red color to {63736, 20817, 18761}
        set ANSI green color to {11822, 41120, 17219}
        set ANSI yellow color to {48059, 32896, 2313}
        set ANSI blue color to {14392, 35723, 65021}
        set ANSI magenta color to {41891, 29041, 63479}
        set ANSI cyan color to {10794, 40349, 39578}
        set ANSI white color to {51657, 53713, 55769}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 30326, 33153}
        set ANSI bright red color to {63736, 20817, 18761}
        set ANSI bright green color to {11822, 41120, 17219}
        set ANSI bright yellow color to {48059, 32896, 2313}
        set ANSI bright blue color to {14392, 35723, 65021}
        set ANSI bright magenta color to {41891, 29041, 63479}
        set ANSI bright cyan color to {10794, 40349, 39578}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
