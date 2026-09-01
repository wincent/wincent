(*
    base16 Pastelón de Amarillos
    Scheme author: Richard Martinez (https://sonofmartinus.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 62708, 54998}
        set foreground color to {17219, 11308, 15163}

        -- Set ANSI Colors
        set ANSI black color to {65535, 62708, 54998}
        set ANSI red color to {48573, 13621, 18504}
        set ANSI green color to {5654, 29812, 20817}
        set ANSI yellow color to {38036, 25700, 0}
        set ANSI blue color to {7710, 23901, 43176}
        set ANSI magenta color to {36237, 16191, 35209}
        set ANSI cyan color to {0, 29298, 28784}
        set ANSI white color to {17219, 11308, 15163}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32896, 24929, 27499}
        set ANSI bright red color to {48573, 13621, 18504}
        set ANSI bright green color to {5654, 29812, 20817}
        set ANSI bright yellow color to {38036, 25700, 0}
        set ANSI bright blue color to {7710, 23901, 43176}
        set ANSI bright magenta color to {36237, 16191, 35209}
        set ANSI bright cyan color to {0, 29298, 28784}
        set ANSI bright white color to {7196, 3855, 8224}
    end tell
end tell
