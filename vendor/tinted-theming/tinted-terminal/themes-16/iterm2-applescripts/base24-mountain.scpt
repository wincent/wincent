(*
    base24 Mountain
    Scheme author: Stefan Weigl-Bosker (https://github.com/sweiglbosker), based on Mountain Theme (https://github.com/mountain-theme/Mountain)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3855, 3855, 3855}
        set foreground color to {51914, 51914, 51914}

        -- Set ANSI Colors
        set ANSI black color to {3855, 3855, 3855}
        set ANSI red color to {44204, 35466, 35980}
        set ANSI green color to {35466, 44204, 35723}
        set ANSI yellow color to {44204, 43433, 35466}
        set ANSI blue color to {36751, 35466, 44204}
        set ANSI magenta color to {44204, 35466, 44204}
        set ANSI cyan color to {35466, 43947, 44204}
        set ANSI white color to {51914, 51914, 51914}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14649, 14649, 14649}
        set ANSI bright red color to {50372, 40606, 41120}
        set ANSI bright green color to {40606, 50372, 40863}
        set ANSI bright yellow color to {50372, 49601, 40606}
        set ANSI bright blue color to {41891, 40606, 50372}
        set ANSI bright magenta color to {50372, 40606, 50372}
        set ANSI bright cyan color to {40606, 50115, 50372}
        set ANSI bright white color to {61680, 61680, 61680}
    end tell
end tell
