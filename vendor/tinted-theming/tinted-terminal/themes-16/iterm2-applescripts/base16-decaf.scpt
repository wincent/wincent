(*
    base16 Decaf
    Scheme author: Alex Mirrington (https://github.com/alexmirrington)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11565, 11565, 11565}
        set foreground color to {52428, 52428, 52428}

        -- Set ANSI Colors
        set ANSI black color to {14649, 14649, 14649}
        set ANSI red color to {65535, 32639, 31611}
        set ANSI green color to {48830, 56026, 30840}
        set ANSI yellow color to {65535, 54998, 31868}
        set ANSI blue color to {37008, 48830, 57825}
        set ANSI magenta color to {61423, 46003, 63479}
        set ANSI cyan color to {48830, 54998, 65535}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20817, 20817, 20817}
        set ANSI bright red color to {65535, 32639, 31611}
        set ANSI bright green color to {48830, 56026, 30840}
        set ANSI bright yellow color to {65535, 54998, 31868}
        set ANSI bright blue color to {37008, 48830, 57825}
        set ANSI bright magenta color to {61423, 46003, 63479}
        set ANSI bright cyan color to {48830, 54998, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
