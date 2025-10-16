(*
    base16 Measured Dark
    Scheme author: Measured (https://measured.co)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 8481, 7967}
        set foreground color to {56540, 56540, 56540}

        -- Set ANSI Colors
        set ANSI black color to {0, 14906, 14392}
        set ANSI red color to {52942, 32382, 36494}
        set ANSI green color to {22102, 49601, 28527}
        set ANSI yellow color to {49087, 44204, 20046}
        set ANSI blue color to {34952, 45232, 56026}
        set ANSI magenta color to {46003, 39835, 57568}
        set ANSI cyan color to {25186, 49344, 48830}
        set ANSI white color to {61423, 61423, 61423}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {0, 21588, 21331}
        set ANSI bright red color to {52942, 32382, 36494}
        set ANSI bright green color to {22102, 49601, 28527}
        set ANSI bright yellow color to {49087, 44204, 20046}
        set ANSI bright blue color to {34952, 45232, 56026}
        set ANSI bright magenta color to {46003, 39835, 57568}
        set ANSI bright cyan color to {25186, 49344, 48830}
        set ANSI bright white color to {62965, 62965, 62965}
    end tell
end tell
