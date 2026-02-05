(*
    base16 Sakura
    Scheme author: Misterio77 (http://github.com/Misterio77)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65278, 60909, 62451}
        set foreground color to {22102, 17476, 18504}

        -- Set ANSI Colors
        set ANSI black color to {65278, 60909, 62451}
        set ANSI red color to {57311, 11565, 21074}
        set ANSI green color to {11822, 37265, 28013}
        set ANSI yellow color to {49858, 38036, 24929}
        set ANSI blue color to {0, 28270, 37779}
        set ANSI magenta color to {24158, 8481, 32896}
        set ANSI cyan color to {7453, 35209, 37265}
        set ANSI white color to {22102, 17476, 18504}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30069, 24415, 25700}
        set ANSI bright red color to {57311, 11565, 21074}
        set ANSI bright green color to {11822, 37265, 28013}
        set ANSI bright yellow color to {49858, 38036, 24929}
        set ANSI bright blue color to {0, 28270, 37779}
        set ANSI bright magenta color to {24158, 8481, 32896}
        set ANSI bright cyan color to {7453, 35209, 37265}
        set ANSI bright white color to {13107, 10537, 11051}
    end tell
end tell
