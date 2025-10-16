(*
    base16 Windows 95 Light
    Scheme author: Fergus Collins (https://github.com/ferguscollins)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64764, 64764, 64764}
        set foreground color to {21588, 21588, 21588}

        -- Set ANSI Colors
        set ANSI black color to {57568, 57568, 57568}
        set ANSI red color to {43176, 0, 0}
        set ANSI green color to {0, 43176, 0}
        set ANSI yellow color to {43176, 21588, 0}
        set ANSI blue color to {0, 0, 43176}
        set ANSI magenta color to {43176, 0, 43176}
        set ANSI cyan color to {0, 43176, 43176}
        set ANSI white color to {10794, 10794, 10794}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {50372, 50372, 50372}
        set ANSI bright red color to {43176, 0, 0}
        set ANSI bright green color to {0, 43176, 0}
        set ANSI bright yellow color to {43176, 21588, 0}
        set ANSI bright blue color to {0, 0, 43176}
        set ANSI bright magenta color to {43176, 0, 43176}
        set ANSI bright cyan color to {0, 43176, 43176}
        set ANSI bright white color to {0, 0, 0}
    end tell
end tell
