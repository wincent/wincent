(*
    base24 Material
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {60138, 60138, 60138}
        set foreground color to {50115, 50115, 50115}

        -- Set ANSI Colors
        set ANSI black color to {8481, 8481, 8481}
        set ANSI red color to {47031, 5140, 7710}
        set ANSI green color to {17733, 31611, 8995}
        set ANSI yellow color to {21331, 42148, 62451}
        set ANSI blue color to {4883, 20046, 45746}
        set ANSI magenta color to {21845, 0, 34695}
        set ANSI cyan color to {3598, 28784, 31868}
        set ANSI white color to {61166, 61166, 61166}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16962, 16962, 16962}
        set ANSI bright red color to {59624, 14906, 16191}
        set ANSI bright green color to {31354, 47802, 14649}
        set ANSI bright yellow color to {65278, 59881, 11822}
        set ANSI bright blue color to {21331, 42148, 62451}
        set ANSI bright magenta color to {43433, 19789, 48059}
        set ANSI bright cyan color to {9766, 47802, 53713}
        set ANSI bright white color to {55512, 55512, 55512}
    end tell
end tell
