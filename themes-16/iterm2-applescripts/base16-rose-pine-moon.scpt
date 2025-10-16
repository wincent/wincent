(*
    base16 Rosé Pine Moon
    Scheme author: Emilia Dunfelt &lt;edun@dunfelt.se&gt;
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8995, 8481, 13878}
        set foreground color to {57568, 57054, 62708}

        -- Set ANSI Colors
        set ANSI black color to {10794, 10023, 16191}
        set ANSI red color to {60395, 28527, 37522}
        set ANSI green color to {15934, 36751, 45232}
        set ANSI yellow color to {60138, 39578, 38807}
        set ANSI blue color to {50372, 42919, 59367}
        set ANSI magenta color to {63222, 49601, 30583}
        set ANSI cyan color to {40092, 53199, 55512}
        set ANSI white color to {57568, 57054, 62708}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14649, 13621, 21074}
        set ANSI bright red color to {60395, 28527, 37522}
        set ANSI bright green color to {15934, 36751, 45232}
        set ANSI bright yellow color to {60138, 39578, 38807}
        set ANSI bright blue color to {50372, 42919, 59367}
        set ANSI bright magenta color to {63222, 49601, 30583}
        set ANSI bright cyan color to {40092, 53199, 55512}
        set ANSI bright white color to {22102, 21074, 28270}
    end tell
end tell
