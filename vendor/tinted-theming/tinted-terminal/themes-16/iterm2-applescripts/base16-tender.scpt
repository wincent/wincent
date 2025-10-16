(*
    base16 tender
    Scheme author: Jacobo Tabernero (https://github/com/jacoborus/tender.vim)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 10280, 10280}
        set foreground color to {61166, 61166, 61166}

        -- Set ANSI Colors
        set ANSI black color to {14392, 14392, 14392}
        set ANSI red color to {62708, 14135, 21331}
        set ANSI green color to {51657, 53456, 23644}
        set ANSI yellow color to {65535, 49858, 19275}
        set ANSI blue color to {46003, 57054, 61423}
        set ANSI magenta color to {54227, 47545, 34695}
        set ANSI cyan color to {29555, 52942, 62708}
        set ANSI white color to {59624, 59624, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18504, 18504, 18504}
        set ANSI bright red color to {62708, 14135, 21331}
        set ANSI bright green color to {51657, 53456, 23644}
        set ANSI bright yellow color to {65535, 49858, 19275}
        set ANSI bright blue color to {46003, 57054, 61423}
        set ANSI bright magenta color to {54227, 47545, 34695}
        set ANSI bright cyan color to {29555, 52942, 62708}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
