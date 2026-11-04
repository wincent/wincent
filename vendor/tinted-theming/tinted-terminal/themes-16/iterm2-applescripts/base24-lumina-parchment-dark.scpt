(*
    base24 Lumina Parchment Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10794, 8481, 5654}
        set foreground color to {61423, 58853, 53456}

        -- Set ANSI Colors
        set ANSI black color to {10794, 8481, 5654}
        set ANSI red color to {54484, 29041, 26985}
        set ANSI green color to {37522, 54227, 47545}
        set ANSI yellow color to {57568, 47802, 27242}
        set ANSI blue color to {38807, 48573, 62708}
        set ANSI magenta color to {48316, 46517, 61166}
        set ANSI cyan color to {34181, 52171, 54227}
        set ANSI white color to {61423, 58853, 53456}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17476, 14906, 11565}
        set ANSI bright red color to {57825, 37779, 35723}
        set ANSI bright green color to {43690, 61166, 53970}
        set ANSI bright yellow color to {64250, 54484, 33924}
        set ANSI bright blue color to {48059, 55255, 65535}
        set ANSI bright magenta color to {60652, 48830, 62451}
        set ANSI bright cyan color to {40606, 58853, 61166}
        set ANSI bright white color to {61423, 58853, 53456}
    end tell
end tell
