(*
    base16 Edge Dark
    Scheme author: cjayross (https://github.com/cjayross), Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 10023, 10537}
        set foreground color to {44975, 45746, 46517}

        -- Set ANSI Colors
        set ANSI black color to {12593, 12850, 13621}
        set ANSI red color to {59367, 29041, 29041}
        set ANSI green color to {41377, 49087, 30840}
        set ANSI yellow color to {56283, 47031, 29812}
        set ANSI blue color to {29555, 46003, 59367}
        set ANSI magenta color to {54227, 37008, 59367}
        set ANSI cyan color to {24158, 47802, 42405}
        set ANSI white color to {51914, 52428, 52942}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15677, 16191, 16962}
        set ANSI bright red color to {59367, 29041, 29041}
        set ANSI bright green color to {41377, 49087, 30840}
        set ANSI bright yellow color to {56283, 47031, 29812}
        set ANSI bright blue color to {29555, 46003, 59367}
        set ANSI bright magenta color to {54227, 37008, 59367}
        set ANSI bright cyan color to {24158, 47802, 42405}
        set ANSI bright white color to {58596, 58853, 59110}
    end tell
end tell
