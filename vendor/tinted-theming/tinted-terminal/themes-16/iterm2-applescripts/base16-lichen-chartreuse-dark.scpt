(*
    base16 Lichen Chartreuse Dark
    Scheme author: Aaron Colichia (https://aaron.colichia.org/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5397, 5654, 4883}
        set foreground color to {57568, 58853, 56026}

        -- Set ANSI Colors
        set ANSI black color to {5397, 5654, 4883}
        set ANSI red color to {58082, 35723, 33410}
        set ANSI green color to {33667, 48573, 42405}
        set ANSI yellow color to {45746, 53456, 33924}
        set ANSI blue color to {30840, 44461, 50372}
        set ANSI magenta color to {49087, 42662, 54484}
        set ANSI cyan color to {40092, 50886, 51657}
        set ANSI white color to {57568, 58853, 56026}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {35209, 37522, 33410}
        set ANSI bright red color to {58082, 35723, 33410}
        set ANSI bright green color to {33667, 48573, 42405}
        set ANSI bright yellow color to {45746, 53456, 33924}
        set ANSI bright blue color to {30840, 44461, 50372}
        set ANSI bright magenta color to {49087, 42662, 54484}
        set ANSI bright cyan color to {40092, 50886, 51657}
        set ANSI bright white color to {64764, 64764, 64250}
    end tell
end tell
