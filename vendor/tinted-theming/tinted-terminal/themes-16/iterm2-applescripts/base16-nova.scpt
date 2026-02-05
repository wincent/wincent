(*
    base16 Nova
    Scheme author: George Essig (https://github.com/gessig), Trevor D. Miller (https://trevordmiller.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {15420, 19532, 21845}
        set foreground color to {50629, 54484, 56797}

        -- Set ANSI Colors
        set ANSI black color to {15420, 19532, 21845}
        set ANSI red color to {33667, 44975, 58853}
        set ANSI green color to {32639, 49601, 51914}
        set ANSI yellow color to {43176, 52942, 37779}
        set ANSI blue color to {33667, 44975, 58853}
        set ANSI magenta color to {39578, 37779, 57825}
        set ANSI cyan color to {62194, 50115, 36751}
        set ANSI white color to {50629, 54484, 56797}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {35209, 39835, 42662}
        set ANSI bright red color to {33667, 44975, 58853}
        set ANSI bright green color to {32639, 49601, 51914}
        set ANSI bright yellow color to {43176, 52942, 37779}
        set ANSI bright blue color to {33667, 44975, 58853}
        set ANSI bright magenta color to {39578, 37779, 57825}
        set ANSI bright cyan color to {62194, 50115, 36751}
        set ANSI bright white color to {21845, 26728, 29555}
    end tell
end tell
