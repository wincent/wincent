(*
    base24 Lumina Ember Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63993, 62708, 60138}
        set foreground color to {14135, 11051, 7710}

        -- Set ANSI Colors
        set ANSI black color to {63993, 62708, 60138}
        set ANSI red color to {33153, 7453, 7453}
        set ANSI green color to {17219, 29555, 10537}
        set ANSI yellow color to {41120, 24929, 5654}
        set ANSI blue color to {9509, 27499, 39321}
        set ANSI magenta color to {25957, 22873, 41377}
        set ANSI cyan color to {0, 29298, 34181}
        set ANSI white color to {14135, 11051, 7710}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {55512, 53713, 50372}
        set ANSI bright red color to {23644, 7453, 6939}
        set ANSI bright green color to {13621, 23901, 8224}
        set ANSI bright yellow color to {34695, 20046, 257}
        set ANSI bright blue color to {0, 22359, 34181}
        set ANSI bright magenta color to {30840, 14135, 25443}
        set ANSI bright cyan color to {0, 23644, 27756}
        set ANSI bright white color to {14135, 11051, 7710}
    end tell
end tell
