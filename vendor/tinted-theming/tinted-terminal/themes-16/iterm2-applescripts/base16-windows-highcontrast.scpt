(*
    base16 Windows High Contrast
    Scheme author: Fergus Collins (https://github.com/ferguscollins)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {49344, 49344, 49344}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {64764, 21588, 21588}
        set ANSI green color to {21588, 64764, 21588}
        set ANSI yellow color to {64764, 64764, 21588}
        set ANSI blue color to {21588, 21588, 64764}
        set ANSI magenta color to {64764, 21588, 64764}
        set ANSI cyan color to {21588, 64764, 64764}
        set ANSI white color to {49344, 49344, 49344}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21588, 21588, 21588}
        set ANSI bright red color to {64764, 21588, 21588}
        set ANSI bright green color to {21588, 64764, 21588}
        set ANSI bright yellow color to {64764, 64764, 21588}
        set ANSI bright blue color to {21588, 21588, 64764}
        set ANSI bright magenta color to {64764, 21588, 64764}
        set ANSI bright cyan color to {21588, 64764, 64764}
        set ANSI bright white color to {64764, 64764, 64764}
    end tell
end tell
