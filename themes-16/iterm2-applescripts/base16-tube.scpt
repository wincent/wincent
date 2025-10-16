(*
    base16 London Tube
    Scheme author: Jan T. Sott
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8995, 7967, 8224}
        set foreground color to {55769, 55512, 55512}

        -- Set ANSI Colors
        set ANSI black color to {7196, 16191, 38293}
        set ANSI red color to {61166, 11822, 9252}
        set ANSI green color to {0, 34181, 15934}
        set ANSI yellow color to {65535, 53970, 1028}
        set ANSI blue color to {0, 40349, 56540}
        set ANSI magenta color to {39064, 0, 23901}
        set ANSI cyan color to {34181, 52942, 48316}
        set ANSI white color to {59367, 59367, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23130, 22359, 22616}
        set ANSI bright red color to {61166, 11822, 9252}
        set ANSI bright green color to {0, 34181, 15934}
        set ANSI bright yellow color to {65535, 53970, 1028}
        set ANSI bright blue color to {0, 40349, 56540}
        set ANSI bright magenta color to {39064, 0, 23901}
        set ANSI bright cyan color to {34181, 52942, 48316}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
