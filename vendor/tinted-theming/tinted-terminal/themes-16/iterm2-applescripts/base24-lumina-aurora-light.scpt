(*
    base24 Lumina Aurora Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62194, 64250, 63993}
        set foreground color to {5654, 12850, 13878}

        -- Set ANSI Colors
        set ANSI black color to {62194, 64250, 63993}
        set ANSI red color to {38036, 10794, 10280}
        set ANSI green color to {514, 28013, 17219}
        set ANSI yellow color to {40863, 24929, 5654}
        set ANSI blue color to {16962, 23387, 31354}
        set ANSI magenta color to {30069, 20303, 42405}
        set ANSI cyan color to {0, 29555, 34438}
        set ANSI white color to {5654, 12850, 13878}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {52685, 55512, 55255}
        set ANSI bright red color to {28013, 10537, 9766}
        set ANSI bright green color to {0, 22359, 13364}
        set ANSI bright yellow color to {34438, 20046, 257}
        set ANSI bright blue color to {5911, 17990, 32125}
        set ANSI bright magenta color to {29555, 14906, 28270}
        set ANSI bright cyan color to {0, 23901, 28013}
        set ANSI bright white color to {5654, 12850, 13878}
    end tell
end tell
