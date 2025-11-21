(*
    base16 Ascendancy
    Scheme author: EmergentMind (https://github.com/emergentmind/ascendancy-scheme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 10280, 10280}
        set foreground color to {54741, 51143, 41377}

        -- Set ANSI Colors
        set ANSI black color to {8481, 12079, 15677}
        set ANSI red color to {49344, 14649, 0}
        set ANSI green color to {47288, 48059, 9766}
        set ANSI yellow color to {65535, 52428, 6939}
        set ANSI blue color to {17733, 34181, 34952}
        set ANSI magenta color to {64250, 48573, 12079}
        set ANSI cyan color to {36751, 16191, 29041}
        set ANSI white color to {60395, 56283, 45746}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20560, 18761, 17733}
        set ANSI bright red color to {49344, 14649, 0}
        set ANSI bright green color to {47288, 48059, 9766}
        set ANSI bright yellow color to {65535, 52428, 6939}
        set ANSI bright blue color to {17733, 34181, 34952}
        set ANSI bright magenta color to {64250, 48573, 12079}
        set ANSI bright cyan color to {36751, 16191, 29041}
        set ANSI bright white color to {64507, 61937, 51143}
    end tell
end tell
