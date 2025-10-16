(*
    base24 Jellybeans
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4626, 4626, 4626}
        set foreground color to {54741, 54741, 54741}

        -- Set ANSI Colors
        set ANSI black color to {37522, 37522, 37522}
        set ANSI red color to {58082, 29555, 29555}
        set ANSI green color to {37779, 47545, 31097}
        set ANSI yellow color to {45489, 55512, 63222}
        set ANSI blue color to {38807, 48830, 56540}
        set ANSI magenta color to {57825, 49344, 64250}
        set ANSI cyan color to {0, 39064, 36494}
        set ANSI white color to {57054, 57054, 57054}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {48573, 48573, 48573}
        set ANSI bright red color to {65535, 41377, 41377}
        set ANSI bright green color to {48573, 57054, 43947}
        set ANSI bright yellow color to {65535, 56540, 41120}
        set ANSI bright blue color to {45489, 55512, 63222}
        set ANSI bright magenta color to {64507, 56026, 65535}
        set ANSI bright cyan color to {6682, 45746, 43176}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
