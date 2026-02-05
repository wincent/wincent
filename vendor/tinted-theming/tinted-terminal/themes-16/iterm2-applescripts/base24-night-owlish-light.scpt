(*
    base24 Night Owlish Light
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {22616, 23387, 23387}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {54227, 16962, 15934}
        set ANSI green color to {10794, 41634, 39064}
        set ANSI yellow color to {56026, 51400, 257}
        set ANSI blue color to {18504, 30326, 54998}
        set ANSI magenta color to {16448, 16191, 21331}
        set ANSI cyan color to {2056, 37265, 27242}
        set ANSI white color to {22616, 23387, 23387}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {45489, 46260, 46260}
        set ANSI bright red color to {63479, 28270, 28270}
        set ANSI bright green color to {18761, 53456, 50629}
        set ANSI bright yellow color to {56026, 49858, 27499}
        set ANSI bright blue color to {23644, 42919, 58596}
        set ANSI bright magenta color to {26985, 28784, 39064}
        set ANSI bright cyan color to {0, 51657, 37008}
        set ANSI bright white color to {257, 5654, 10023}
    end tell
end tell
