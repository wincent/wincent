(*
    base16 Tomorrow Night
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 7967, 8481}
        set foreground color to {50629, 51400, 50886}

        -- Set ANSI Colors
        set ANSI black color to {10280, 10794, 11822}
        set ANSI red color to {52428, 26214, 26214}
        set ANSI green color to {46517, 48573, 26728}
        set ANSI yellow color to {61680, 50886, 29812}
        set ANSI blue color to {33153, 41634, 48830}
        set ANSI magenta color to {45746, 38036, 48059}
        set ANSI cyan color to {35466, 48830, 47031}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14135, 15163, 16705}
        set ANSI bright red color to {52428, 26214, 26214}
        set ANSI bright green color to {46517, 48573, 26728}
        set ANSI bright yellow color to {61680, 50886, 29812}
        set ANSI bright blue color to {33153, 41634, 48830}
        set ANSI bright magenta color to {45746, 38036, 48059}
        set ANSI bright cyan color to {35466, 48830, 47031}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
