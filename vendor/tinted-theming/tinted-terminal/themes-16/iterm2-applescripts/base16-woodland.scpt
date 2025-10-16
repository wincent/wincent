(*
    base16 Woodland
    Scheme author: Jay Cornwall (https://jcornwall.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8995, 7710, 6168}
        set foreground color to {51914, 48316, 45489}

        -- Set ANSI Colors
        set ANSI black color to {12336, 11051, 9509}
        set ANSI red color to {54227, 23644, 23644}
        set ANSI green color to {47031, 47802, 21331}
        set ANSI yellow color to {57568, 44204, 5654}
        set ANSI blue color to {34952, 42148, 54227}
        set ANSI magenta color to {48059, 37008, 58082}
        set ANSI cyan color to {28270, 47545, 22616}
        set ANSI white color to {55255, 51400, 48316}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18504, 16705, 14906}
        set ANSI bright red color to {54227, 23644, 23644}
        set ANSI bright green color to {47031, 47802, 21331}
        set ANSI bright yellow color to {57568, 44204, 5654}
        set ANSI bright blue color to {34952, 42148, 54227}
        set ANSI bright magenta color to {48059, 37008, 58082}
        set ANSI bright cyan color to {28270, 47545, 22616}
        set ANSI bright white color to {58596, 54484, 51400}
    end tell
end tell
