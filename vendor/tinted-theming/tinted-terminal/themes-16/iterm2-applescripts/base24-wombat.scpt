(*
    base24 Wombat
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5911, 5911, 5911}
        set foreground color to {45746, 44975, 42662}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 24672, 23130}
        set ANSI green color to {45489, 59624, 26985}
        set ANSI yellow color to {42405, 51143, 65535}
        set ANSI blue color to {23901, 43433, 63222}
        set ANSI magenta color to {59624, 27242, 65535}
        set ANSI cyan color to {33410, 65535, 63222}
        set ANSI white color to {57054, 55769, 52942}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12593, 12593, 12593}
        set ANSI bright red color to {62965, 35723, 32639}
        set ANSI bright green color to {56540, 63736, 36751}
        set ANSI bright yellow color to {61166, 58853, 45746}
        set ANSI bright blue color to {42405, 51143, 65535}
        set ANSI bright magenta color to {56797, 43690, 65535}
        set ANSI bright cyan color to {46774, 65535, 63993}
        set ANSI bright white color to {65278, 65535, 65278}
    end tell
end tell
