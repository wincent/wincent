(*
    base16 Atelier Dune
    Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 8224, 7453}
        set foreground color to {42662, 41634, 35980}

        -- Set ANSI Colors
        set ANSI black color to {10537, 10280, 9252}
        set ANSI red color to {55255, 14135, 14135}
        set ANSI green color to {24672, 44204, 14649}
        set ANSI yellow color to {44718, 38293, 4883}
        set ANSI blue color to {26214, 33924, 57825}
        set ANSI magenta color to {47288, 21588, 54484}
        set ANSI cyan color to {7967, 44461, 33667}
        set ANSI white color to {59624, 58596, 53199}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 27499, 24158}
        set ANSI bright red color to {55255, 14135, 14135}
        set ANSI bright green color to {24672, 44204, 14649}
        set ANSI bright yellow color to {44718, 38293, 4883}
        set ANSI bright blue color to {26214, 33924, 57825}
        set ANSI bright magenta color to {47288, 21588, 54484}
        set ANSI bright cyan color to {7967, 44461, 33667}
        set ANSI bright white color to {65278, 64507, 60652}
    end tell
end tell
