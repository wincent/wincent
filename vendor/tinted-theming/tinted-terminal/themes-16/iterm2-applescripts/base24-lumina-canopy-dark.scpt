(*
    base24 Lumina Canopy Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3084, 6939, 4112}
        set foreground color to {55512, 58339, 54998}

        -- Set ANSI Colors
        set ANSI black color to {3084, 6939, 4112}
        set ANSI red color to {54741, 28784, 26728}
        set ANSI green color to {39321, 53456, 42148}
        set ANSI yellow color to {53713, 52428, 43176}
        set ANSI blue color to {39578, 51914, 61937}
        set ANSI magenta color to {49087, 47288, 62451}
        set ANSI cyan color to {34438, 53199, 55255}
        set ANSI white color to {55512, 58339, 54998}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {8738, 13364, 10023}
        set ANSI bright red color to {57825, 37522, 35723}
        set ANSI bright green color to {45746, 60395, 48573}
        set ANSI bright yellow color to {62708, 59367, 37522}
        set ANSI bright blue color to {49344, 58339, 65535}
        set ANSI bright magenta color to {65021, 50629, 63736}
        set ANSI bright cyan color to {40863, 59881, 61937}
        set ANSI bright white color to {55512, 58339, 54998}
    end tell
end tell
