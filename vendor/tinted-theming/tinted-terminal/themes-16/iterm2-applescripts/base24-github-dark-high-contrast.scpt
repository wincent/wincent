(*
    base24 Github Dark High Contrast
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 4369, 5911}
        set foreground color to {53713, 55255, 57568}

        -- Set ANSI Colors
        set ANSI black color to {3341, 4369, 5911}
        set ANSI red color to {65535, 38036, 37522}
        set ANSI green color to {10280, 55255, 20817}
        set ANSI yellow color to {61680, 47031, 12079}
        set ANSI blue color to {29041, 47031, 65535}
        set ANSI magenta color to {52171, 40606, 65535}
        set ANSI cyan color to {14649, 50629, 53199}
        set ANSI white color to {53713, 55255, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25957, 27756, 30326}
        set ANSI bright red color to {65535, 45489, 44975}
        set ANSI bright green color to {19018, 57825, 26728}
        set ANSI bright yellow color to {63479, 51400, 17219}
        set ANSI bright blue color to {37265, 52171, 65535}
        set ANSI bright magenta color to {56283, 47031, 65535}
        set ANSI bright cyan color to {22102, 54484, 56797}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
