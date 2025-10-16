(*
    base16 Twilight
    Scheme author: David Hart (https://github.com/hartbit)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 7710, 7710}
        set foreground color to {42919, 42919, 42919}

        -- Set ANSI Colors
        set ANSI black color to {12850, 13621, 14135}
        set ANSI red color to {53199, 27242, 19532}
        set ANSI green color to {36751, 40349, 27242}
        set ANSI yellow color to {63993, 61166, 39064}
        set ANSI blue color to {30069, 34695, 42662}
        set ANSI magenta color to {39835, 34181, 40349}
        set ANSI cyan color to {44975, 50372, 56283}
        set ANSI white color to {50115, 50115, 50115}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17990, 19275, 20560}
        set ANSI bright red color to {53199, 27242, 19532}
        set ANSI bright green color to {36751, 40349, 27242}
        set ANSI bright yellow color to {63993, 61166, 39064}
        set ANSI bright blue color to {30069, 34695, 42662}
        set ANSI bright magenta color to {39835, 34181, 40349}
        set ANSI bright cyan color to {44975, 50372, 56283}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
