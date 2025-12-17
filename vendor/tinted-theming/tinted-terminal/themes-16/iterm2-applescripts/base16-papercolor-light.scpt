(*
    base16 PaperColor Light
    Scheme author: Jon Leopard (http://github.com/jonleopard), Tinted Theming (https://github.com/tinted-theming), based on PaperColor Theme (https://github.com/NLKNguyen/papercolor-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61166, 61166, 61166}
        set foreground color to {24158, 24158, 24158}

        -- Set ANSI Colors
        set ANSI black color to {50372, 50372, 50372}
        set ANSI red color to {55255, 0, 0}
        set ANSI green color to {0, 34695, 0}
        set ANSI yellow color to {55255, 24415, 0}
        set ANSI blue color to {0, 24415, 34695}
        set ANSI magenta color to {34695, 0, 44975}
        set ANSI cyan color to {0, 34695, 44975}
        set ANSI white color to {21074, 21074, 21074}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {40606, 40606, 40606}
        set ANSI bright red color to {55255, 0, 0}
        set ANSI bright green color to {0, 34695, 0}
        set ANSI bright yellow color to {55255, 24415, 0}
        set ANSI bright blue color to {0, 24415, 34695}
        set ANSI bright magenta color to {34695, 0, 44975}
        set ANSI bright cyan color to {0, 34695, 44975}
        set ANSI bright white color to {17476, 17476, 17476}
    end tell
end tell
