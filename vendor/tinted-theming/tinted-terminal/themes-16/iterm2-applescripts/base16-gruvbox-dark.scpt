(*
    base16 Gruvbox dark
    Scheme author: Tinted Theming (https://github.com/tinted-theming), morhetz (https://github.com/morhetz/gruvbox)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 10280, 10280}
        set foreground color to {60395, 56283, 45746}

        -- Set ANSI Colors
        set ANSI black color to {15420, 14392, 13878}
        set ANSI red color to {52428, 9252, 7453}
        set ANSI green color to {39064, 38807, 6682}
        set ANSI yellow color to {55255, 39321, 8481}
        set ANSI blue color to {17733, 34181, 34952}
        set ANSI magenta color to {45489, 25186, 34438}
        set ANSI cyan color to {26728, 40349, 27242}
        set ANSI white color to {64507, 61937, 51143}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20560, 18761, 17733}
        set ANSI bright red color to {52428, 9252, 7453}
        set ANSI bright green color to {39064, 38807, 6682}
        set ANSI bright yellow color to {55255, 39321, 8481}
        set ANSI bright blue color to {17733, 34181, 34952}
        set ANSI bright magenta color to {45489, 25186, 34438}
        set ANSI bright cyan color to {26728, 40349, 27242}
        set ANSI bright white color to {63993, 62965, 55255}
    end tell
end tell
