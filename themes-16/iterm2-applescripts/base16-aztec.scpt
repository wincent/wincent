(*
    base16 Aztec
    Scheme author: TheNeverMan (github.com/TheNeverMan)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 5654, 0}
        set foreground color to {65535, 56026, 20817}

        -- Set ANSI Colors
        set ANSI black color to {6682, 7710, 257}
        set ANSI red color to {61166, 11822, 0}
        set ANSI green color to {25443, 55769, 12850}
        set ANSI yellow color to {61166, 48059, 0}
        set ANSI blue color to {23387, 19018, 40863}
        set ANSI magenta color to {34952, 15934, 40863}
        set ANSI cyan color to {15677, 38036, 42405}
        set ANSI white color to {65535, 57825, 30840}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {9252, 9766, 1028}
        set ANSI bright red color to {61166, 11822, 0}
        set ANSI bright green color to {25443, 55769, 12850}
        set ANSI bright yellow color to {61166, 48059, 0}
        set ANSI bright blue color to {23387, 19018, 40863}
        set ANSI bright magenta color to {34952, 15934, 40863}
        set ANSI bright cyan color to {15677, 38036, 42405}
        set ANSI bright white color to {65535, 60395, 41120}
    end tell
end tell
