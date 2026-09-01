(*
    base16 Gruvbox Dark Medium (Forest)
    Scheme author: Muhammad Talha (muhammadtalha.quant@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 10280, 10280}
        set foreground color to {54741, 50372, 41377}

        -- Set ANSI Colors
        set ANSI black color to {10280, 10280, 10280}
        set ANSI red color to {64507, 18761, 13364}
        set ANSI green color to {47288, 48059, 9766}
        set ANSI yellow color to {64250, 48573, 12079}
        set ANSI blue color to {47288, 48059, 9766}
        set ANSI magenta color to {38550, 48573, 41634}
        set ANSI cyan color to {24415, 27756, 7967}
        set ANSI white color to {54741, 50372, 41377}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 23644, 20560}
        set ANSI bright red color to {64507, 18761, 13364}
        set ANSI bright green color to {47288, 48059, 9766}
        set ANSI bright yellow color to {64250, 48573, 12079}
        set ANSI bright blue color to {47288, 48059, 9766}
        set ANSI bright magenta color to {38550, 48573, 41634}
        set ANSI bright cyan color to {24415, 27756, 7967}
        set ANSI bright white color to {64507, 61937, 51143}
    end tell
end tell
