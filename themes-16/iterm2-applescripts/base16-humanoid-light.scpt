(*
    base16 Humanoid light
    Scheme author: Thomas (tasmo) Friese
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63736, 63736, 62194}
        set foreground color to {8995, 9766, 10537}

        -- Set ANSI Colors
        set ANSI black color to {61423, 61423, 59881}
        set ANSI red color to {45232, 5397, 6682}
        set ANSI green color to {14392, 36494, 15420}
        set ANSI yellow color to {65535, 46774, 10023}
        set ANSI blue color to {0, 33410, 51657}
        set ANSI magenta color to {28784, 3855, 39064}
        set ANSI cyan color to {0, 36494, 36494}
        set ANSI white color to {12079, 13107, 14135}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {57054, 57054, 55512}
        set ANSI bright red color to {45232, 5397, 6682}
        set ANSI bright green color to {14392, 36494, 15420}
        set ANSI bright yellow color to {65535, 46774, 10023}
        set ANSI bright blue color to {0, 33410, 51657}
        set ANSI bright magenta color to {28784, 3855, 39064}
        set ANSI bright cyan color to {0, 36494, 36494}
        set ANSI bright white color to {1799, 1799, 2056}
    end tell
end tell
