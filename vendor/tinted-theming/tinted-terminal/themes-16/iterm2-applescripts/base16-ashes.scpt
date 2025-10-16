(*
    base16 Ashes
    Scheme author: Jannik Siebert (https://github.com/janniks)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 8224, 8995}
        set foreground color to {51143, 52428, 53713}

        -- Set ANSI Colors
        set ANSI black color to {14649, 16191, 17733}
        set ANSI red color to {51143, 44718, 38293}
        set ANSI green color to {38293, 51143, 44718}
        set ANSI yellow color to {44718, 51143, 38293}
        set ANSI blue color to {44718, 38293, 51143}
        set ANSI magenta color to {51143, 38293, 44718}
        set ANSI cyan color to {38293, 44718, 51143}
        set ANSI white color to {57311, 58082, 58853}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22102, 24158, 25957}
        set ANSI bright red color to {51143, 44718, 38293}
        set ANSI bright green color to {38293, 51143, 44718}
        set ANSI bright yellow color to {44718, 51143, 38293}
        set ANSI bright blue color to {44718, 38293, 51143}
        set ANSI bright magenta color to {51143, 38293, 44718}
        set ANSI bright cyan color to {38293, 44718, 51143}
        set ANSI bright white color to {62451, 62708, 62965}
    end tell
end tell
