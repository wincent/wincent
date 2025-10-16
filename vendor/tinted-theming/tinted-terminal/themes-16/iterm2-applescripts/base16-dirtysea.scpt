(*
    base16 dirtysea
    Scheme author: Kahlil (Kal) Hodgson
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {57568, 57568, 57568}
        set foreground color to {0, 0, 0}

        -- Set ANSI Colors
        set ANSI black color to {53456, 56026, 53456}
        set ANSI red color to {33924, 0, 0}
        set ANSI green color to {29555, 0, 29555}
        set ANSI yellow color to {30069, 23387, 0}
        set ANSI blue color to {0, 29555, 0}
        set ANSI magenta color to {0, 0, 37008}
        set ANSI cyan color to {30069, 23387, 0}
        set ANSI white color to {63736, 63736, 63736}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {53456, 53456, 53456}
        set ANSI bright red color to {33924, 0, 0}
        set ANSI bright green color to {29555, 0, 29555}
        set ANSI bright yellow color to {30069, 23387, 0}
        set ANSI bright blue color to {0, 29555, 0}
        set ANSI bright magenta color to {0, 0, 37008}
        set ANSI bright cyan color to {30069, 23387, 0}
        set ANSI bright white color to {50372, 55769, 50372}
    end tell
end tell
