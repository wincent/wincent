(*
    base24 Oceanic Material
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 9766, 11051}
        set foreground color to {39064, 39064, 39064}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {61166, 10794, 10537}
        set ANSI green color to {16191, 41891, 16191}
        set ANSI yellow color to {21331, 42148, 62451}
        set ANSI blue color to {7453, 32896, 61423}
        set ANSI magenta color to {34952, 0, 41120}
        set ANSI cyan color to {5654, 44718, 51657}
        set ANSI white color to {42148, 42148, 42148}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30326, 30326, 30326}
        set ANSI bright red color to {56540, 23387, 24672}
        set ANSI bright green color to {28784, 48830, 29041}
        set ANSI bright yellow color to {65278, 61680, 25443}
        set ANSI bright blue color to {21331, 42148, 62451}
        set ANSI bright magenta color to {43433, 19789, 48059}
        set ANSI bright cyan color to {16962, 50886, 55769}
        set ANSI bright white color to {65535, 65278, 65278}
    end tell
end tell
