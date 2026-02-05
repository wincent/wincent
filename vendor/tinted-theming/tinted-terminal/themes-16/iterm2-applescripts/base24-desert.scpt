(*
    base24 Desert
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {13107, 13107, 13107}
        set foreground color to {52685, 48059, 39835}

        -- Set ANSI Colors
        set ANSI black color to {13107, 13107, 13107}
        set ANSI red color to {65535, 11051, 11051}
        set ANSI green color to {39064, 64507, 39064}
        set ANSI yellow color to {34695, 52942, 65535}
        set ANSI blue color to {52685, 34181, 16191}
        set ANSI magenta color to {65535, 57054, 44461}
        set ANSI cyan color to {65535, 41120, 41120}
        set ANSI white color to {52685, 48059, 39835}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32125, 30583, 27756}
        set ANSI bright red color to {65535, 21845, 21845}
        set ANSI bright green color to {21845, 65535, 21845}
        set ANSI bright yellow color to {65535, 65535, 21845}
        set ANSI bright blue color to {34695, 52942, 65535}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {65535, 55255, 0}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
