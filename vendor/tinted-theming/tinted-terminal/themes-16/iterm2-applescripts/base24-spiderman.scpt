(*
    base24 Spiderman
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 7453, 7710}
        set foreground color to {54227, 54227, 52685}

        -- Set ANSI Colors
        set ANSI black color to {6939, 7453, 7710}
        set ANSI red color to {59110, 1799, 4626}
        set ANSI green color to {58082, 10280, 10280}
        set ANSI yellow color to {7453, 20303, 65535}
        set ANSI blue color to {11051, 16191, 65535}
        set ANSI magenta color to {9252, 13621, 56283}
        set ANSI cyan color to {12850, 21845, 65535}
        set ANSI white color to {65535, 65278, 63222}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20560, 21331, 21588}
        set ANSI bright red color to {65535, 771, 9509}
        set ANSI bright green color to {65535, 12850, 14392}
        set ANSI bright yellow color to {65278, 14649, 13621}
        set ANSI bright blue color to {7453, 20303, 65535}
        set ANSI bright magenta color to {29555, 31611, 65535}
        set ANSI bright cyan color to {24672, 33667, 65535}
        set ANSI bright white color to {65278, 65535, 63993}
    end tell
end tell
