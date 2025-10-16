(*
    base16 Penumbra Dark Contrast Plus
    Scheme author: Zachary Weiss (https://github.com/zacharyweiss)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 6939, 7967}
        set foreground color to {52942, 52942, 52942}

        -- Set ANSI Colors
        set ANSI black color to {9252, 10023, 11051}
        set ANSI red color to {57311, 32639, 30840}
        set ANSI green color to {20560, 46517, 33924}
        set ANSI yellow color to {40092, 42919, 18504}
        set ANSI blue color to {24929, 41891, 59110}
        set ANSI magenta color to {42148, 36751, 57825}
        set ANSI cyan color to {0, 46003, 49858}
        set ANSI white color to {65535, 63479, 60909}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15934, 16448, 17476}
        set ANSI bright red color to {57311, 32639, 30840}
        set ANSI bright green color to {20560, 46517, 33924}
        set ANSI bright yellow color to {40092, 42919, 18504}
        set ANSI bright blue color to {24929, 41891, 59110}
        set ANSI bright magenta color to {42148, 36751, 57825}
        set ANSI bright cyan color to {0, 46003, 49858}
        set ANSI bright white color to {65535, 65021, 64507}
    end tell
end tell
