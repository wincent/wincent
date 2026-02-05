(*
    base16 Windows High Contrast Light
    Scheme author: Fergus Collins (https://github.com/ferguscollins)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64764, 64764, 64764}
        set foreground color to {21588, 21588, 21588}

        -- Set ANSI Colors
        set ANSI black color to {64764, 64764, 64764}
        set ANSI red color to {32896, 0, 0}
        set ANSI green color to {0, 32896, 0}
        set ANSI yellow color to {32896, 32896, 0}
        set ANSI blue color to {0, 0, 32896}
        set ANSI magenta color to {32896, 0, 32896}
        set ANSI cyan color to {0, 32896, 32896}
        set ANSI white color to {21588, 21588, 21588}

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
