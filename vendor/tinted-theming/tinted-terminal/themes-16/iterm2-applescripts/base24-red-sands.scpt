(*
    base24 Red Sands
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {31097, 9252, 7710}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 16191, 0}
        set ANSI green color to {0, 48059, 0}
        set ANSI yellow color to {0, 29041, 44718}
        set ANSI blue color to {0, 29041, 65535}
        set ANSI magenta color to {48059, 0, 48059}
        set ANSI cyan color to {0, 48059, 48059}
        set ANSI white color to {48059, 48059, 48059}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {48059, 0, 0}
        set ANSI bright green color to {0, 48059, 0}
        set ANSI bright yellow color to {59367, 45232, 0}
        set ANSI bright blue color to {0, 29041, 44718}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {21845, 65535, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
