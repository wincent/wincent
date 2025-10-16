(*
    base16 Pop
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8224, 8224}
        set ANSI red color to {60395, 0, 35466}
        set ANSI green color to {14135, 46003, 18761}
        set ANSI yellow color to {63736, 51914, 4626}
        set ANSI blue color to {3598, 23130, 38036}
        set ANSI magenta color to {46003, 7710, 36237}
        set ANSI cyan color to {0, 43690, 48059}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12336, 12336, 12336}
        set ANSI bright red color to {60395, 0, 35466}
        set ANSI bright green color to {14135, 46003, 18761}
        set ANSI bright yellow color to {63736, 51914, 4626}
        set ANSI bright blue color to {3598, 23130, 38036}
        set ANSI bright magenta color to {46003, 7710, 36237}
        set ANSI bright cyan color to {0, 43690, 48059}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
