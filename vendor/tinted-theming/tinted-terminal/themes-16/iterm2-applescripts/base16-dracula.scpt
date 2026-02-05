(*
    base16 Dracula
    Scheme author: Jamy Golden (http://github.com/JamyGolden), based on Dracula Theme (http://github.com/dracula)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 10794, 13878}
        set foreground color to {63736, 63736, 62194}

        -- Set ANSI Colors
        set ANSI black color to {10280, 10794, 13878}
        set ANSI red color to {65535, 21845, 21845}
        set ANSI green color to {20560, 64250, 31611}
        set ANSI yellow color to {61937, 64250, 35980}
        set ANSI blue color to {32896, 49087, 65535}
        set ANSI magenta color to {65535, 31097, 50886}
        set ANSI cyan color to {35723, 59881, 65021}
        set ANSI white color to {63736, 63736, 62194}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25186, 29298, 42148}
        set ANSI bright red color to {65535, 21845, 21845}
        set ANSI bright green color to {20560, 64250, 31611}
        set ANSI bright yellow color to {61937, 64250, 35980}
        set ANSI bright blue color to {32896, 49087, 65535}
        set ANSI bright magenta color to {65535, 31097, 50886}
        set ANSI bright cyan color to {35723, 59881, 65021}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
