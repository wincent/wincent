(*
    base24 Tomorrow Night
    Scheme author: Cody Buell (https://github.com/codybuell)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 7967, 8481}
        set foreground color to {50629, 51400, 50886}

        -- Set ANSI Colors
        set ANSI black color to {7453, 7967, 8481}
        set ANSI red color to {52428, 26214, 26214}
        set ANSI green color to {46517, 48573, 26728}
        set ANSI yellow color to {61680, 50886, 29812}
        set ANSI blue color to {33153, 41634, 48830}
        set ANSI magenta color to {45746, 38036, 48059}
        set ANSI cyan color to {35466, 48830, 47031}
        set ANSI white color to {50629, 51400, 50886}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {38550, 39064, 38550}
        set ANSI bright red color to {59367, 19532, 15420}
        set ANSI bright green color to {47288, 54484, 46003}
        set ANSI bright yellow color to {63479, 56540, 28527}
        set ANSI bright blue color to {34181, 49601, 59881}
        set ANSI bright magenta color to {55255, 41891, 51914}
        set ANSI bright cyan color to {38293, 54227, 52942}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
