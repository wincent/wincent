(*
    base24 Firefox Dev
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3598, 4112, 4369}
        set foreground color to {42405, 44204, 44718}

        -- Set ANSI Colors
        set ANSI black color to {3598, 4112, 4369}
        set ANSI red color to {59110, 14392, 21331}
        set ANSI green color to {24158, 47288, 15420}
        set ANSI yellow color to {0, 28527, 49344}
        set ANSI blue color to {13621, 40349, 57311}
        set ANSI magenta color to {55255, 23644, 65535}
        set ANSI cyan color to {19275, 29555, 41634}
        set ANSI white color to {42405, 44204, 44718}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14135, 19789, 21331}
        set ANSI bright red color to {57825, 0, 16191}
        set ANSI bright green color to {7453, 37008, 0}
        set ANSI bright yellow color to {52428, 37779, 2056}
        set ANSI bright blue color to {0, 28527, 49344}
        set ANSI bright magenta color to {41634, 0, 56026}
        set ANSI bright cyan color to {0, 22359, 38036}
        set ANSI bright white color to {58082, 58082, 58082}
    end tell
end tell
