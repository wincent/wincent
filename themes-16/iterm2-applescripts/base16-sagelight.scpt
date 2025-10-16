(*
    base16 Sagelight
    Scheme author: Carter Veldhuizen
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63736, 63736, 63736}
        set foreground color to {14392, 14392, 14392}

        -- Set ANSI Colors
        set ANSI black color to {59624, 59624, 59624}
        set ANSI red color to {64250, 33924, 32896}
        set ANSI green color to {41120, 53970, 51400}
        set ANSI yellow color to {65535, 56540, 24929}
        set ANSI blue color to {41120, 42919, 53970}
        set ANSI magenta color to {51400, 41120, 53970}
        set ANSI cyan color to {41634, 54998, 62965}
        set ANSI white color to {10280, 10280, 10280}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {55512, 55512, 55512}
        set ANSI bright red color to {64250, 33924, 32896}
        set ANSI bright green color to {41120, 53970, 51400}
        set ANSI bright yellow color to {65535, 56540, 24929}
        set ANSI bright blue color to {41120, 42919, 53970}
        set ANSI bright magenta color to {51400, 41120, 53970}
        set ANSI bright cyan color to {41634, 54998, 62965}
        set ANSI bright white color to {6168, 6168, 6168}
    end tell
end tell
