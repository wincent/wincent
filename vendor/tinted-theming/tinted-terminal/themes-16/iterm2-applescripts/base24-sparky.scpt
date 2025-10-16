(*
    base24 Sparky
    Scheme author: Leila Sother (https://github.com/mixcoac)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {1799, 11051, 12593}
        set foreground color to {62708, 62965, 61680}

        -- Set ANSI Colors
        set ANSI black color to {0, 12593, 15420}
        set ANSI red color to {65535, 22616, 23901}
        set ANSI green color to {30840, 54998, 19275}
        set ANSI yellow color to {64507, 56797, 16448}
        set ANSI blue color to {17990, 39064, 52171}
        set ANSI magenta color to {54741, 40606, 55255}
        set ANSI cyan color to {11565, 52428, 54227}
        set ANSI white color to {62965, 62965, 61937}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {0, 15420, 17990}
        set ANSI bright red color to {65535, 29298, 30326}
        set ANSI bright green color to {36494, 56797, 25957}
        set ANSI bright yellow color to {63222, 60395, 24929}
        set ANSI bright blue color to {26985, 46003, 59367}
        set ANSI bright magenta color to {63993, 40863, 51657}
        set ANSI bright cyan color to {0, 49601, 54741}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
