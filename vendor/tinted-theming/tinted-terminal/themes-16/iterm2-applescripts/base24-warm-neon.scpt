(*
    base24 Warm Neon
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {16191, 16191, 16191}
        set foreground color to {56540, 51657, 47802}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {58082, 17219, 17733}
        set ANSI green color to {14392, 45489, 14649}
        set ANSI yellow color to {31354, 37008, 54741}
        set ANSI blue color to {16962, 24672, 50629}
        set ANSI magenta color to {63736, 7967, 64507}
        set ANSI cyan color to {10537, 47802, 54227}
        set ANSI white color to {53456, 47288, 41891}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {65021, 64764, 64764}
        set ANSI bright red color to {59624, 28527, 29041}
        set ANSI bright green color to {39835, 49344, 36751}
        set ANSI bright yellow color to {56797, 55769, 31097}
        set ANSI bright blue color to {31354, 37008, 54741}
        set ANSI bright magenta color to {63222, 29812, 47545}
        set ANSI bright cyan color to {24158, 53713, 58596}
        set ANSI bright white color to {55512, 51400, 48059}
    end tell
end tell
