(*
    base24 Lichen Chartreuse Light
    Scheme author: Aaron Colichia (https://aaron.colichia.org/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62965, 63479, 62194}
        set foreground color to {11565, 12336, 11051}

        -- Set ANSI Colors
        set ANSI black color to {62965, 63479, 62194}
        set ANSI red color to {41891, 18247, 16448}
        set ANSI green color to {12079, 29812, 25186}
        set ANSI yellow color to {20560, 27499, 10537}
        set ANSI blue color to {13621, 28270, 35466}
        set ANSI magenta color to {28270, 22102, 35209}
        set ANSI cyan color to {13621, 25957, 26985}
        set ANSI white color to {11565, 12336, 11051}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26728, 29041, 24929}
        set ANSI bright red color to {41891, 18247, 16448}
        set ANSI bright green color to {20560, 27499, 10537}
        set ANSI bright yellow color to {34695, 24158, 8224}
        set ANSI bright blue color to {15163, 28013, 34438}
        set ANSI bright magenta color to {35466, 20303, 26471}
        set ANSI bright cyan color to {16191, 25700, 25700}
        set ANSI bright white color to {5397, 5654, 4883}
    end tell
end tell
