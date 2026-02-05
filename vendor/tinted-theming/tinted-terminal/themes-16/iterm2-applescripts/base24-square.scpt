(*
    base24 Square
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 6682, 6682}
        set foreground color to {47802, 47802, 47802}

        -- Set ANSI Colors
        set ANSI black color to {6682, 6682, 6682}
        set ANSI red color to {59881, 35209, 31868}
        set ANSI green color to {46774, 14135, 32125}
        set ANSI yellow color to {46774, 57054, 64507}
        set ANSI blue color to {43433, 52685, 60395}
        set ANSI magenta color to {30069, 20560, 31611}
        set ANSI cyan color to {51657, 51914, 60652}
        set ANSI white color to {47802, 47802, 47802}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {19275, 19275, 19275}
        set ANSI bright red color to {63993, 37522, 34438}
        set ANSI bright green color to {50115, 63479, 34438}
        set ANSI bright yellow color to {64764, 64507, 52428}
        set ANSI bright blue color to {46774, 57054, 64507}
        set ANSI bright magenta color to {44461, 32639, 43176}
        set ANSI bright cyan color to {55255, 55769, 64764}
        set ANSI bright white color to {58082, 58082, 58082}
    end tell
end tell
