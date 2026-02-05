(*
    base24 Birds Of Paradise
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10794, 7710, 7453}
        set foreground color to {52685, 48830, 39835}

        -- Set ANSI Colors
        set ANSI black color to {10794, 7710, 7453}
        set ANSI red color to {48830, 11565, 9766}
        set ANSI green color to {27499, 41120, 35466}
        set ANSI yellow color to {47288, 54227, 60909}
        set ANSI blue color to {23130, 34438, 44204}
        set ANSI magenta color to {43947, 32896, 42662}
        set ANSI cyan color to {29812, 42405, 44204}
        set ANSI white color to {52685, 48830, 39835}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {43947, 34438, 25700}
        set ANSI bright red color to {59624, 17733, 9766}
        set ANSI bright green color to {38036, 55255, 47802}
        set ANSI bright yellow color to {53456, 53456, 20303}
        set ANSI bright blue color to {47288, 54227, 60909}
        set ANSI bright magenta color to {53456, 40349, 51914}
        set ANSI bright cyan color to {37522, 52942, 54998}
        set ANSI bright white color to {65535, 63993, 54484}
    end tell
end tell
