(*
    base24 Idle Toes
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {12850, 12850, 12850}
        set foreground color to {51143, 51143, 50629}

        -- Set ANSI Colors
        set ANSI black color to {12850, 12850, 12850}
        set ANSI red color to {53970, 21074, 21074}
        set ANSI green color to {32639, 57825, 29555}
        set ANSI yellow color to {24158, 47031, 63479}
        set ANSI blue color to {16448, 39064, 65535}
        set ANSI magenta color to {62965, 32639, 65535}
        set ANSI cyan color to {48830, 54998, 65535}
        set ANSI white color to {61166, 61166, 60652}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21331, 21331, 21331}
        set ANSI bright red color to {61680, 28784, 28784}
        set ANSI bright green color to {40349, 65535, 37008}
        set ANSI bright yellow color to {65535, 58596, 35723}
        set ANSI bright blue color to {24158, 47031, 63479}
        set ANSI bright magenta color to {65535, 40349, 65535}
        set ANSI bright cyan color to {56540, 62708, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
