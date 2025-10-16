(*
    base16 Edge Dark
    Scheme author: cjayross (https://github.com/cjayross)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 10023, 10537}
        set foreground color to {47031, 48830, 51657}

        -- Set ANSI Colors
        set ANSI black color to {34952, 37008, 40863}
        set ANSI red color to {59367, 29041, 29041}
        set ANSI green color to {41377, 49087, 30840}
        set ANSI yellow color to {56283, 47031, 29812}
        set ANSI blue color to {29555, 46003, 59367}
        set ANSI magenta color to {54227, 37008, 59367}
        set ANSI cyan color to {24158, 47802, 42405}
        set ANSI white color to {54227, 37008, 59367}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {47031, 48830, 51657}
        set ANSI bright red color to {59367, 29041, 29041}
        set ANSI bright green color to {41377, 49087, 30840}
        set ANSI bright yellow color to {56283, 47031, 29812}
        set ANSI bright blue color to {29555, 46003, 59367}
        set ANSI bright magenta color to {54227, 37008, 59367}
        set ANSI bright cyan color to {24158, 47802, 42405}
        set ANSI bright white color to {15934, 16962, 18761}
    end tell
end tell
