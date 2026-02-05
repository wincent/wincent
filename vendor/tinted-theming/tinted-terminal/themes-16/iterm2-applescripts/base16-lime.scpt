(*
    base16 lime
    Scheme author: limelier
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 6682, 12079}
        set foreground color to {33153, 33153, 30069}

        -- Set ANSI Colors
        set ANSI black color to {6682, 6682, 12079}
        set ANSI red color to {65535, 26214, 10794}
        set ANSI green color to {35980, 55769, 31868}
        set ANSI yellow color to {65535, 53713, 24158}
        set ANSI blue color to {11051, 37522, 28527}
        set ANSI magenta color to {6939, 33410, 24415}
        set ANSI cyan color to {19532, 44461, 33667}
        set ANSI white color to {33153, 33153, 30069}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12593, 12593, 16448}
        set ANSI bright red color to {65535, 26214, 10794}
        set ANSI bright green color to {35980, 55769, 31868}
        set ANSI bright yellow color to {65535, 53713, 24158}
        set ANSI bright blue color to {11051, 37522, 28527}
        set ANSI bright magenta color to {6939, 33410, 24415}
        set ANSI bright cyan color to {19532, 44461, 33667}
        set ANSI bright white color to {65535, 63736, 57825}
    end tell
end tell
