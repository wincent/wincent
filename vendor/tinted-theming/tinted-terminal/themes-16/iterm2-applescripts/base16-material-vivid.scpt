(*
    base16 Material Vivid
    Scheme author: joshyrobot
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 8481, 9252}
        set foreground color to {32896, 34438, 35723}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8481, 9252}
        set ANSI red color to {62708, 17219, 13878}
        set ANSI green color to {0, 59110, 30326}
        set ANSI yellow color to {65535, 60395, 15163}
        set ANSI blue color to {8481, 38550, 62451}
        set ANSI magenta color to {26471, 14906, 47031}
        set ANSI cyan color to {0, 48316, 54484}
        set ANSI white color to {32896, 34438, 35723}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17476, 17990, 19789}
        set ANSI bright red color to {62708, 17219, 13878}
        set ANSI bright green color to {0, 59110, 30326}
        set ANSI bright yellow color to {65535, 60395, 15163}
        set ANSI bright blue color to {8481, 38550, 62451}
        set ANSI bright magenta color to {26471, 14906, 47031}
        set ANSI bright cyan color to {0, 48316, 54484}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
