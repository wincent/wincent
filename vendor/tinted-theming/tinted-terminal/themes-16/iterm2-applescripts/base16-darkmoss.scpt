(*
    base16 darkmoss
    Scheme author: Gabriel Avanzi (https://github.com/avanzzzi)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5911, 7710, 7967}
        set foreground color to {51143, 51143, 42405}

        -- Set ANSI Colors
        set ANSI black color to {5911, 7710, 7967}
        set ANSI red color to {65535, 17990, 22616}
        set ANSI green color to {18761, 37265, 32896}
        set ANSI yellow color to {65021, 45489, 7967}
        set ANSI blue color to {18761, 32896, 37265}
        set ANSI magenta color to {39835, 49344, 51400}
        set ANSI cyan color to {26214, 55769, 61423}
        set ANSI white color to {51143, 51143, 42405}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 24158, 24415}
        set ANSI bright red color to {65535, 17990, 22616}
        set ANSI bright green color to {18761, 37265, 32896}
        set ANSI bright yellow color to {65021, 45489, 7967}
        set ANSI bright blue color to {18761, 32896, 37265}
        set ANSI bright magenta color to {39835, 49344, 51400}
        set ANSI bright cyan color to {26214, 55769, 61423}
        set ANSI bright white color to {57825, 60138, 61423}
    end tell
end tell
