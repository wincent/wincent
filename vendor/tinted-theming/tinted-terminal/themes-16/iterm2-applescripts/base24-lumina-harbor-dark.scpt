(*
    base24 Lumina Harbor Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 4369, 7453}
        set foreground color to {56797, 57825, 60395}

        -- Set ANSI Colors
        set ANSI black color to {3341, 4369, 7453}
        set ANSI red color to {53456, 30069, 27756}
        set ANSI green color to {39835, 55512, 46260}
        set ANSI yellow color to {60138, 52942, 35980}
        set ANSI blue color to {37265, 50629, 60138}
        set ANSI magenta color to {49601, 48059, 61423}
        set ANSI cyan color to {37265, 53199, 54998}
        set ANSI white color to {56797, 57825, 60395}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {8995, 10280, 14135}
        set ANSI bright red color to {57054, 38550, 36494}
        set ANSI bright green color to {47545, 61937, 53456}
        set ANSI bright yellow color to {65535, 58853, 43433}
        set ANSI bright blue color to {45489, 57054, 65535}
        set ANSI bright magenta color to {60395, 50372, 62965}
        set ANSI bright cyan color to {43690, 59881, 61680}
        set ANSI bright white color to {56797, 57825, 60395}
    end tell
end tell
