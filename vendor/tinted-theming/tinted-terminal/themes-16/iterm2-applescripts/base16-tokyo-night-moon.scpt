(*
    base16 Tokyo Night Moon
    Scheme author: Ólafur Bjarki Bogason
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8738, 9252, 13878}
        set foreground color to {33410, 35723, 47288}

        -- Set ANSI Colors
        set ANSI black color to {7710, 8224, 12336}
        set ANSI red color to {65535, 30069, 32639}
        set ANSI green color to {50115, 59624, 36237}
        set ANSI yellow color to {65535, 57311, 30583}
        set ANSI blue color to {33410, 43690, 65535}
        set ANSI magenta color to {64764, 42919, 60138}
        set ANSI cyan color to {34438, 57825, 64764}
        set ANSI white color to {44718, 46260, 53713}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {11565, 16191, 30326}
        set ANSI bright red color to {65535, 30069, 32639}
        set ANSI bright green color to {50115, 59624, 36237}
        set ANSI bright yellow color to {65535, 57311, 30583}
        set ANSI bright blue color to {33410, 43690, 65535}
        set ANSI bright magenta color to {64764, 42919, 60138}
        set ANSI bright cyan color to {34438, 57825, 64764}
        set ANSI bright white color to {51400, 54227, 62965}
    end tell
end tell
