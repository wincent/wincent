(*
    base24 Solarized Dark Higher Contrast
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 7710, 9766}
        set foreground color to {44718, 49858, 47802}

        -- Set ANSI Colors
        set ANSI black color to {0, 10023, 12593}
        set ANSI red color to {53456, 6939, 9252}
        set ANSI green color to {27499, 48830, 27756}
        set ANSI yellow color to {5911, 36237, 51143}
        set ANSI blue color to {8224, 30069, 51143}
        set ANSI magenta color to {50886, 6939, 28270}
        set ANSI cyan color to {9509, 37265, 34181}
        set ANSI white color to {59881, 58082, 52171}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {0, 25443, 34952}
        set ANSI bright red color to {62708, 5397, 15163}
        set ANSI bright green color to {20560, 61166, 33924}
        set ANSI bright yellow color to {45489, 32382, 10280}
        set ANSI bright blue color to {5911, 36237, 51143}
        set ANSI bright magenta color to {57825, 19789, 36494}
        set ANSI bright cyan color to {0, 45746, 40606}
        set ANSI bright white color to {64764, 62708, 56540}
    end tell
end tell
