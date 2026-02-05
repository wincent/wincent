(*
    base16 Windows NT Light
    Scheme author: Fergus Collins (https://github.com/ferguscollins)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {32896, 32896, 32896}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {32896, 0, 0}
        set ANSI green color to {0, 32896, 0}
        set ANSI yellow color to {32896, 32896, 0}
        set ANSI blue color to {0, 0, 32896}
        set ANSI magenta color to {32896, 0, 32896}
        set ANSI cyan color to {0, 32896, 32896}
        set ANSI white color to {32896, 32896, 32896}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {49344, 49344, 49344}
        set ANSI bright red color to {32896, 0, 0}
        set ANSI bright green color to {0, 32896, 0}
        set ANSI bright yellow color to {32896, 32896, 0}
        set ANSI bright blue color to {0, 0, 32896}
        set ANSI bright magenta color to {32896, 0, 32896}
        set ANSI bright cyan color to {0, 32896, 32896}
        set ANSI bright white color to {0, 0, 0}
    end tell
end tell
