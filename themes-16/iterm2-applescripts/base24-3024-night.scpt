(*
    base24 3024 Night
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2313, 771, 0}
        set foreground color to {37522, 36751, 36494}

        -- Set ANSI Colors
        set ANSI black color to {2313, 771, 0}
        set ANSI red color to {56283, 11565, 8224}
        set ANSI green color to {257, 41634, 21074}
        set ANSI yellow color to {32896, 32125, 31868}
        set ANSI blue color to {257, 41120, 58596}
        set ANSI magenta color to {41377, 27242, 38036}
        set ANSI cyan color to {46517, 58596, 62708}
        set ANSI white color to {42405, 41634, 41634}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23644, 22616, 21845}
        set ANSI bright red color to {59624, 48059, 53456}
        set ANSI bright green color to {14906, 13364, 12850}
        set ANSI bright yellow color to {19018, 17733, 17219}
        set ANSI bright blue color to {32896, 32125, 31868}
        set ANSI bright magenta color to {54998, 54741, 54484}
        set ANSI bright cyan color to {52685, 43947, 21331}
        set ANSI bright white color to {63479, 63479, 63479}
    end tell
end tell
