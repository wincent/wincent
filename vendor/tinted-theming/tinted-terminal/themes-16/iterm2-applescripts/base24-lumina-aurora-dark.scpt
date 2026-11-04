(*
    base24 Lumina Aurora Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {1028, 4626, 4626}
        set foreground color to {54998, 58339, 58082}

        -- Set ANSI Colors
        set ANSI black color to {1028, 4626, 4626}
        set ANSI red color to {55512, 28527, 26214}
        set ANSI green color to {27756, 55255, 40349}
        set ANSI yellow color to {59881, 54484, 34695}
        set ANSI blue color to {50629, 55512, 60909}
        set ANSI magenta color to {49087, 40606, 61937}
        set ANSI cyan color to {33924, 53970, 56283}
        set ANSI white color to {54998, 58339, 58082}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {6168, 10794, 10794}
        set ANSI bright red color to {58853, 37522, 35209}
        set ANSI bright green color to {42919, 60138, 49858}
        set ANSI bright yellow color to {65535, 59367, 37265}
        set ANSI bright blue color to {55255, 60138, 65535}
        set ANSI bright magenta color to {65535, 51657, 63993}
        set ANSI bright cyan color to {40349, 60652, 63222}
        set ANSI bright white color to {54998, 58339, 58082}
    end tell
end tell
