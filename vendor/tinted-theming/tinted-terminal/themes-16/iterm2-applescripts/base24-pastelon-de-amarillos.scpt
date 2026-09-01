(*
    base24 Pastelón de Amarillos
    Scheme author: Richard Martinez (https://sonofmartinus.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 62708, 54998}
        set foreground color to {17219, 11308, 15163}

        -- Set ANSI Colors
        set ANSI black color to {65535, 62708, 54998}
        set ANSI red color to {42662, 15677, 19018}
        set ANSI green color to {12850, 28784, 22102}
        set ANSI yellow color to {33924, 26214, 0}
        set ANSI blue color to {13878, 24415, 37265}
        set ANSI magenta color to {30840, 19018, 30840}
        set ANSI cyan color to {10023, 28270, 27756}
        set ANSI white color to {17219, 11308, 15163}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32896, 24929, 27499}
        set ANSI bright red color to {43176, 28270, 0}
        set ANSI bright green color to {0, 31611, 30840}
        set ANSI bright yellow color to {0, 31611, 20046}
        set ANSI bright blue color to {39835, 13107, 38293}
        set ANSI bright magenta color to {34695, 12336, 7967}
        set ANSI bright cyan color to {0, 24158, 47288}
        set ANSI bright white color to {7196, 3855, 8224}
    end tell
end tell
