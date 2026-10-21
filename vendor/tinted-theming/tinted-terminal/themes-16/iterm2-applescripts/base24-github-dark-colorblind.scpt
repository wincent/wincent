(*
    base24 Github Dark Colorblind
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 4369, 5911}
        set foreground color to {53713, 55255, 57568}

        -- Set ANSI Colors
        set ANSI black color to {3341, 4369, 5911}
        set ANSI red color to {61680, 34952, 15934}
        set ANSI green color to {22616, 42662, 65535}
        set ANSI yellow color to {53970, 39321, 8738}
        set ANSI blue color to {22616, 42662, 65535}
        set ANSI magenta color to {48830, 36751, 65535}
        set ANSI cyan color to {14649, 50629, 53199}
        set ANSI white color to {53713, 55255, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25957, 27756, 30326}
        set ANSI bright red color to {65535, 42662, 22359}
        set ANSI bright green color to {31097, 49344, 65535}
        set ANSI bright yellow color to {58339, 46003, 16705}
        set ANSI bright blue color to {31097, 49344, 65535}
        set ANSI bright magenta color to {53970, 43176, 65535}
        set ANSI bright cyan color to {22102, 54484, 56797}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
