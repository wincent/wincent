(*
    base24 Mission Brogue
    Scheme author: Thomas Leon Highbaugh
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 12593, 14649}
        set foreground color to {37779, 42405, 46260}

        -- Set ANSI Colors
        set ANSI black color to {15163, 18761, 21588}
        set ANSI red color to {61423, 43433, 43433}
        set ANSI green color to {35980, 54484, 45232}
        set ANSI yellow color to {57568, 47288, 35466}
        set ANSI blue color to {41634, 50629, 65021}
        set ANSI magenta color to {52428, 47031, 56283}
        set ANSI cyan color to {37779, 57311, 60652}
        set ANSI white color to {43947, 47545, 50372}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {19789, 24672, 28527}
        set ANSI bright red color to {63222, 49087, 49087}
        set ANSI bright green color to {46517, 57568, 37008}
        set ANSI bright yellow color to {65535, 61680, 45746}
        set ANSI bright blue color to {50115, 55769, 65021}
        set ANSI bright magenta color to {58339, 50115, 59110}
        set ANSI bright cyan color to {45746, 61680, 65021}
        set ANSI bright white color to {59367, 60395, 61166}
    end tell
end tell
