(*
    base24 Lumina Olive Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 6939, 3084}
        set foreground color to {57825, 57311, 52942}

        -- Set ANSI Colors
        set ANSI black color to {6682, 6939, 3084}
        set ANSI red color to {54227, 29298, 27242}
        set ANSI green color to {46517, 54741, 50886}
        set ANSI yellow color to {60395, 49858, 31868}
        set ANSI blue color to {41634, 50372, 61680}
        set ANSI magenta color to {49344, 47802, 62194}
        set ANSI cyan color to {35723, 53199, 55255}
        set ANSI white color to {57825, 57311, 52942}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12850, 13364, 8738}
        set ANSI bright red color to {57568, 37779, 35980}
        set ANSI bright green color to {46517, 63479, 56026}
        set ANSI bright yellow color to {65535, 57054, 42919}
        set ANSI bright blue color to {50372, 56797, 65535}
        set ANSI bright magenta color to {61680, 48059, 60395}
        set ANSI bright cyan color to {41891, 59881, 62194}
        set ANSI bright white color to {57825, 57311, 52942}
    end tell
end tell
