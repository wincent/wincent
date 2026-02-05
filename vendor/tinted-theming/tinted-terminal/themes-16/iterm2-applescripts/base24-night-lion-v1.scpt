(*
    base24 Night Lion V1
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {48059, 0, 0}
        set ANSI green color to {24158, 57054, 36751}
        set ANSI yellow color to {21845, 21845, 65535}
        set ANSI blue color to {9766, 27242, 55255}
        set ANSI magenta color to {48059, 0, 48059}
        set ANSI cyan color to {0, 55769, 57311}
        set ANSI white color to {41377, 41377, 41377}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 28270, 28270}
        set ANSI bright red color to {65535, 21845, 21845}
        set ANSI bright green color to {21845, 65535, 21845}
        set ANSI bright yellow color to {65535, 65535, 21845}
        set ANSI bright blue color to {21845, 21845, 65535}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {21845, 65535, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
