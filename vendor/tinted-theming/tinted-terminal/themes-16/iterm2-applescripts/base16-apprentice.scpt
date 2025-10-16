(*
    base16 Apprentice
    Scheme author: romainl
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 9766, 9766}
        set foreground color to {24415, 24415, 34695}

        -- Set ANSI Colors
        set ANSI black color to {44975, 24415, 24415}
        set ANSI red color to {17476, 17476, 17476}
        set ANSI green color to {65535, 65535, 44975}
        set ANSI yellow color to {34695, 44975, 34695}
        set ANSI blue color to {34695, 34695, 44975}
        set ANSI magenta color to {24415, 44975, 44975}
        set ANSI cyan color to {34695, 44975, 55255}
        set ANSI white color to {24415, 34695, 34695}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24415, 34695, 24415}
        set ANSI bright red color to {17476, 17476, 17476}
        set ANSI bright green color to {65535, 65535, 44975}
        set ANSI bright yellow color to {34695, 44975, 34695}
        set ANSI bright blue color to {34695, 34695, 44975}
        set ANSI bright magenta color to {24415, 44975, 44975}
        set ANSI bright cyan color to {34695, 44975, 55255}
        set ANSI bright white color to {27756, 27756, 27756}
    end tell
end tell
