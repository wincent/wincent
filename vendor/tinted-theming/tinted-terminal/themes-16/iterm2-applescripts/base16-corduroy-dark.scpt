(*
    base16 Corduroy Dark
    Scheme author: taysatte (https://github.com/taysatte)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5140, 4112, 5654}
        set foreground color to {56797, 55512, 57311}

        -- Set ANSI Colors
        set ANSI black color to {5140, 4112, 5654}
        set ANSI red color to {59624, 30069, 35466}
        set ANSI green color to {21845, 41120, 41120}
        set ANSI yellow color to {61680, 48573, 40092}
        set ANSI blue color to {56540, 37522, 41891}
        set ANSI magenta color to {53199, 39064, 50372}
        set ANSI cyan color to {61680, 43176, 39835}
        set ANSI white color to {56797, 55512, 57311}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32125, 28784, 33410}
        set ANSI bright red color to {59624, 30069, 35466}
        set ANSI bright green color to {21845, 41120, 41120}
        set ANSI bright yellow color to {61680, 48573, 40092}
        set ANSI bright blue color to {56540, 37522, 41891}
        set ANSI bright magenta color to {53199, 39064, 50372}
        set ANSI bright cyan color to {61680, 43176, 39835}
        set ANSI bright white color to {23130, 20817, 24672}
    end tell
end tell
