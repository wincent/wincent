(*
    base24 Lumina Lagoon Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {1028, 10537, 12336}
        set foreground color to {55255, 59110, 59367}

        -- Set ANSI Colors
        set ANSI black color to {1028, 10537, 12336}
        set ANSI red color to {54227, 29298, 27242}
        set ANSI green color to {40863, 54484, 43433}
        set ANSI yellow color to {59367, 53199, 38036}
        set ANSI blue color to {36494, 50115, 63993}
        set ANSI magenta color to {51400, 47802, 63222}
        set ANSI cyan color to {23130, 54227, 54998}
        set ANSI white color to {55255, 59110, 59367}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {7196, 17219, 19275}
        set ANSI bright red color to {57568, 37779, 35980}
        set ANSI bright green color to {47288, 61423, 49858}
        set ANSI bright yellow color to {65535, 59110, 42919}
        set ANSI bright blue color to {47802, 56540, 65535}
        set ANSI bright magenta color to {65535, 51914, 63993}
        set ANSI bright cyan color to {40863, 59110, 59624}
        set ANSI bright white color to {55255, 59110, 59367}
    end tell
end tell
