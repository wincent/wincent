(*
    base16 Tango
    Scheme author: @Schnouki, based on the Tango Desktop Project
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11822, 13364, 13878}
        set foreground color to {54227, 55255, 53199}

        -- Set ANSI Colors
        set ANSI black color to {11822, 13364, 13878}
        set ANSI red color to {52428, 0, 0}
        set ANSI green color to {20046, 39578, 1542}
        set ANSI yellow color to {50372, 41120, 0}
        set ANSI blue color to {13364, 25957, 42148}
        set ANSI magenta color to {30069, 20560, 31611}
        set ANSI cyan color to {1542, 39064, 39578}
        set ANSI white color to {54227, 55255, 53199}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 22359, 21331}
        set ANSI bright red color to {52428, 0, 0}
        set ANSI bright green color to {20046, 39578, 1542}
        set ANSI bright yellow color to {50372, 41120, 0}
        set ANSI bright blue color to {13364, 25957, 42148}
        set ANSI bright magenta color to {30069, 20560, 31611}
        set ANSI bright cyan color to {1542, 39064, 39578}
        set ANSI bright white color to {61166, 61166, 60652}
    end tell
end tell
