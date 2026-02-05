(*
    base16 Everforest Dark Medium
    Scheme author: Sainnhe Park (https://github.com/sainnhe)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11565, 13621, 15163}
        set foreground color to {34181, 37522, 35209}

        -- Set ANSI Colors
        set ANSI black color to {11565, 13621, 15163}
        set ANSI red color to {59110, 32382, 32896}
        set ANSI green color to {42919, 49344, 32896}
        set ANSI yellow color to {56283, 48316, 32639}
        set ANSI blue color to {32639, 48059, 46003}
        set ANSI magenta color to {54998, 39321, 46774}
        set ANSI cyan color to {33667, 49344, 37522}
        set ANSI white color to {34181, 37522, 35209}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18247, 21074, 22616}
        set ANSI bright red color to {59110, 32382, 32896}
        set ANSI bright green color to {42919, 49344, 32896}
        set ANSI bright yellow color to {56283, 48316, 32639}
        set ANSI bright blue color to {32639, 48059, 46003}
        set ANSI bright magenta color to {54998, 39321, 46774}
        set ANSI bright cyan color to {33667, 49344, 37522}
        set ANSI bright white color to {54227, 50886, 43690}
    end tell
end tell
