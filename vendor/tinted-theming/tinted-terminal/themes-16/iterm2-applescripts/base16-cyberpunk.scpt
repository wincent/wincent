(*
    base16 Cyberpunk
    Scheme author: benjujo
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {56540, 56540, 52428}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 0, 0}
        set ANSI green color to {24929, 52942, 15420}
        set ANSI yellow color to {65535, 65535, 0}
        set ANSI blue color to {19532, 33667, 65535}
        set ANSI magenta color to {65535, 5140, 37779}
        set ANSI cyan color to {37779, 57568, 58339}
        set ANSI white color to {56540, 56540, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20303, 20303, 20303}
        set ANSI bright red color to {65535, 0, 0}
        set ANSI bright green color to {24929, 52942, 15420}
        set ANSI bright yellow color to {65535, 65535, 0}
        set ANSI bright blue color to {19532, 33667, 65535}
        set ANSI bright magenta color to {65535, 5140, 37779}
        set ANSI bright cyan color to {37779, 57568, 58339}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
