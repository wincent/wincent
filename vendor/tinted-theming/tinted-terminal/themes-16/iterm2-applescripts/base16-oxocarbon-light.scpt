(*
    base16 Oxocarbon Light
    Scheme author: shaunsingh/IBM
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62194, 62708, 63736}
        set foreground color to {14649, 14649, 14649}

        -- Set ANSI Colors
        set ANSI black color to {56797, 57825, 59110}
        set ANSI red color to {65535, 32382, 46774}
        set ANSI green color to {3855, 25186, 65278}
        set ANSI yellow color to {65535, 28527, 0}
        set ANSI blue color to {16962, 48830, 25957}
        set ANSI magenta color to {48830, 38293, 65535}
        set ANSI cyan color to {26471, 14906, 47031}
        set ANSI white color to {21074, 21074, 21074}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21074, 21074, 21074}
        set ANSI bright red color to {65535, 32382, 46774}
        set ANSI bright green color to {3855, 25186, 65278}
        set ANSI bright yellow color to {65535, 28527, 0}
        set ANSI bright blue color to {16962, 48830, 25957}
        set ANSI bright magenta color to {48830, 38293, 65535}
        set ANSI bright cyan color to {26471, 14906, 47031}
        set ANSI bright white color to {2056, 48573, 47802}
    end tell
end tell
