(*
    base16 PaperColor Light
    Scheme author: Jon Leopard (http://github.com/jonleopard), based on PaperColor Theme (https://github.com/NLKNguyen/papercolor-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61166, 61166, 61166}
        set foreground color to {17476, 17476, 17476}

        -- Set ANSI Colors
        set ANSI black color to {44975, 0, 0}
        set ANSI red color to {48316, 48316, 48316}
        set ANSI green color to {34695, 0, 44975}
        set ANSI yellow color to {55255, 0, 34695}
        set ANSI blue color to {55255, 24415, 0}
        set ANSI magenta color to {0, 24415, 44975}
        set ANSI cyan color to {55255, 24415, 0}
        set ANSI white color to {0, 24415, 34695}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {0, 34695, 0}
        set ANSI bright red color to {48316, 48316, 48316}
        set ANSI bright green color to {34695, 0, 44975}
        set ANSI bright yellow color to {55255, 0, 34695}
        set ANSI bright blue color to {55255, 24415, 0}
        set ANSI bright magenta color to {0, 24415, 44975}
        set ANSI bright cyan color to {55255, 24415, 0}
        set ANSI bright white color to {34695, 34695, 34695}
    end tell
end tell
