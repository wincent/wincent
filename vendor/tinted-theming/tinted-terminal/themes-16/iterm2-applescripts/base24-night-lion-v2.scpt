(*
    base24 Night Lion V2
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5911, 5911, 5911}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {19532, 19532, 19532}
        set ANSI red color to {48059, 0, 0}
        set ANSI green color to {771, 63222, 8738}
        set ANSI yellow color to {25186, 51914, 59367}
        set ANSI blue color to {25443, 53456, 61680}
        set ANSI magenta color to {52942, 28527, 56026}
        set ANSI cyan color to {0, 55769, 57311}
        set ANSI white color to {48059, 48059, 48059}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {65535, 21845, 21845}
        set ANSI bright green color to {32125, 63222, 7196}
        set ANSI bright yellow color to {65535, 65535, 21845}
        set ANSI bright blue color to {25186, 51914, 59367}
        set ANSI bright magenta color to {65535, 39578, 62965}
        set ANSI bright cyan color to {0, 52428, 55255}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
