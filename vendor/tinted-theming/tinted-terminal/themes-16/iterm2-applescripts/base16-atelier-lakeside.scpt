(*
    base16 Atelier Lakeside
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 6939, 7453}
        set foreground color to {32382, 41634, 46260}

        -- Set ANSI Colors
        set ANSI black color to {5654, 6939, 7453}
        set ANSI red color to {53970, 11565, 29298}
        set ANSI green color to {22102, 35980, 15163}
        set ANSI yellow color to {35466, 35466, 3855}
        set ANSI blue color to {9509, 32639, 44461}
        set ANSI magenta color to {27499, 27499, 47288}
        set ANSI cyan color to {11565, 36751, 28527}
        set ANSI white color to {32382, 41634, 46260}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23130, 31611, 35980}
        set ANSI bright red color to {53970, 11565, 29298}
        set ANSI bright green color to {22102, 35980, 15163}
        set ANSI bright yellow color to {35466, 35466, 3855}
        set ANSI bright blue color to {9509, 32639, 44461}
        set ANSI bright magenta color to {27499, 27499, 47288}
        set ANSI bright cyan color to {11565, 36751, 28527}
        set ANSI bright white color to {60395, 63736, 65535}
    end tell
end tell
