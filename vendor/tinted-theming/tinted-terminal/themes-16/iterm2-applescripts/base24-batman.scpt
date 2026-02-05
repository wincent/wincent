(*
    base24 Batman
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 7453, 7710}
        set foreground color to {42919, 43176, 41891}

        -- Set ANSI Colors
        set ANSI black color to {6939, 7453, 7710}
        set ANSI red color to {59110, 56283, 17219}
        set ANSI green color to {51400, 48830, 17990}
        set ANSI yellow color to {37008, 38036, 38293}
        set ANSI blue color to {29555, 28784, 29812}
        set ANSI magenta color to {29555, 29298, 29041}
        set ANSI cyan color to {24929, 24415, 24158}
        set ANSI white color to {42919, 43176, 41891}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28013, 28527, 28270}
        set ANSI bright red color to {65535, 63222, 36237}
        set ANSI bright green color to {65535, 62194, 31868}
        set ANSI bright yellow color to {65278, 60909, 27756}
        set ANSI bright blue color to {37008, 38036, 38293}
        set ANSI bright magenta color to {39578, 39321, 40349}
        set ANSI bright cyan color to {41634, 41634, 42405}
        set ANSI bright white color to {56026, 56026, 54741}
    end tell
end tell
