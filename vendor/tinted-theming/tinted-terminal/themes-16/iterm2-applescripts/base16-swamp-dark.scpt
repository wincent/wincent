(*
    base16 Swamp Dark
    Scheme author: Masroof Maindak (https://github.com/masroof-maindak)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 8224, 5397}
        set foreground color to {53970, 50115, 42148}

        -- Set ANSI Colors
        set ANSI black color to {9252, 8224, 5397}
        set ANSI red color to {56283, 37779, 3341}
        set ANSI green color to {31354, 30326, 21331}
        set ANSI yellow color to {43176, 11565, 22102}
        set ANSI blue color to {49601, 26214, 27499}
        set ANSI magenta color to {37265, 20560, 27756}
        set ANSI cyan color to {56283, 37779, 3341}
        set ANSI white color to {53970, 50115, 42148}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24415, 20046, 16705}
        set ANSI bright red color to {56283, 37779, 3341}
        set ANSI bright green color to {31354, 30326, 21331}
        set ANSI bright yellow color to {43176, 11565, 22102}
        set ANSI bright blue color to {49601, 26214, 27499}
        set ANSI bright magenta color to {37265, 20560, 27756}
        set ANSI bright cyan color to {56283, 37779, 3341}
        set ANSI bright white color to {61937, 59881, 53456}
    end tell
end tell
