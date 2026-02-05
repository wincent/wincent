(*
    base16 Chinoiserie
    Scheme author: Di Wang (https://cs.cmu.edu/~diw3)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {19018, 16448, 13621}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {49344, 18504, 20817}
        set ANSI green color to {16962, 34438, 30069}
        set ANSI yellow color to {54998, 41120, 7453}
        set ANSI blue color to {33153, 23644, 38036}
        set ANSI magenta color to {49344, 36494, 44975}
        set ANSI cyan color to {11051, 29555, 44975}
        set ANSI white color to {19018, 16448, 13621}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32896, 30326, 28270}
        set ANSI bright red color to {49344, 18504, 20817}
        set ANSI bright green color to {16962, 34438, 30069}
        set ANSI bright yellow color to {54998, 41120, 7453}
        set ANSI bright blue color to {33153, 23644, 38036}
        set ANSI bright magenta color to {49344, 36494, 44975}
        set ANSI bright cyan color to {11051, 29555, 44975}
        set ANSI bright white color to {4883, 4369, 9252}
    end tell
end tell
