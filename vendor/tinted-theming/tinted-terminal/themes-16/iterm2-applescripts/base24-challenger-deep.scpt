(*
    base24 Challenger Deep
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 7196, 12593}
        set foreground color to {37522, 39835, 46774}

        -- Set ANSI Colors
        set ANSI black color to {7710, 7196, 12593}
        set ANSI red color to {65535, 21588, 22616}
        set ANSI green color to {25186, 53713, 38550}
        set ANSI yellow color to {37265, 56797, 65535}
        set ANSI blue color to {25957, 45746, 65535}
        set ANSI magenta color to {37008, 27756, 65535}
        set ANSI cyan color to {25443, 62194, 61937}
        set ANSI white color to {37522, 39835, 46774}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27242, 27756, 35466}
        set ANSI bright red color to {65535, 32896, 32896}
        set ANSI bright green color to {38293, 65535, 42148}
        set ANSI bright yellow color to {65535, 59881, 43690}
        set ANSI bright blue color to {37265, 56797, 65535}
        set ANSI bright magenta color to {51657, 37265, 57825}
        set ANSI bright cyan color to {43690, 65535, 58596}
        set ANSI bright white color to {52171, 58339, 59367}
    end tell
end tell
