(*
    base16 Katy
    Scheme author: George Essig (https://github.com/gessig)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10537, 11565, 15934}
        set foreground color to {38293, 40349, 52171}

        -- Set ANSI Colors
        set ANSI black color to {17476, 16962, 26471}
        set ANSI red color to {28270, 39064, 57825}
        set ANSI green color to {30840, 49344, 28270}
        set ANSI yellow color to {57568, 42405, 22359}
        set ANSI blue color to {33410, 43690, 65535}
        set ANSI magenta color to {51143, 37522, 60138}
        set ANSI cyan color to {33667, 47031, 58853}
        set ANSI white color to {38293, 40349, 52171}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23644, 22873, 35723}
        set ANSI bright red color to {28270, 39064, 57825}
        set ANSI bright green color to {30840, 49344, 28270}
        set ANSI bright yellow color to {57568, 42405, 22359}
        set ANSI bright blue color to {33410, 43690, 65535}
        set ANSI bright magenta color to {51143, 37522, 60138}
        set ANSI bright cyan color to {33667, 47031, 58853}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
