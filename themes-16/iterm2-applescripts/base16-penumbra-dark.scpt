(*
    base16 Penumbra Dark
    Scheme author: Zachary Weiss (https://github.com/zacharyweiss)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 10023, 11051}
        set foreground color to {48830, 48830, 48830}

        -- Set ANSI Colors
        set ANSI black color to {12336, 13107, 14392}
        set ANSI red color to {51914, 29555, 27756}
        set ANSI green color to {18247, 42148, 30583}
        set ANSI yellow color to {36237, 38807, 16705}
        set ANSI blue color to {22359, 38036, 53456}
        set ANSI magenta color to {38036, 33153, 52428}
        set ANSI cyan color to {0, 41634, 44975}
        set ANSI white color to {65535, 63479, 60909}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15934, 16448, 17476}
        set ANSI bright red color to {51914, 29555, 27756}
        set ANSI bright green color to {18247, 42148, 30583}
        set ANSI bright yellow color to {36237, 38807, 16705}
        set ANSI bright blue color to {22359, 38036, 53456}
        set ANSI bright magenta color to {38036, 33153, 52428}
        set ANSI bright cyan color to {0, 41634, 44975}
        set ANSI bright white color to {65535, 65021, 64507}
    end tell
end tell
