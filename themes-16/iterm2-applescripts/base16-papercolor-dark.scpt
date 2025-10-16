(*
    base16 PaperColor Dark
    Scheme author: Jon Leopard (http://github.com/jonleopard), based on PaperColor Theme (https://github.com/NLKNguyen/papercolor-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 7196, 7196}
        set foreground color to {32896, 32896, 32896}

        -- Set ANSI Colors
        set ANSI black color to {44975, 0, 24415}
        set ANSI red color to {22616, 22616, 22616}
        set ANSI green color to {44975, 34695, 55255}
        set ANSI yellow color to {44975, 55255, 0}
        set ANSI blue color to {65535, 24415, 44975}
        set ANSI magenta color to {0, 44975, 44975}
        set ANSI cyan color to {65535, 44975, 0}
        set ANSI white color to {55255, 34695, 24415}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24415, 44975, 0}
        set ANSI bright red color to {22616, 22616, 22616}
        set ANSI bright green color to {44975, 34695, 55255}
        set ANSI bright yellow color to {44975, 55255, 0}
        set ANSI bright blue color to {65535, 24415, 44975}
        set ANSI bright magenta color to {0, 44975, 44975}
        set ANSI bright cyan color to {65535, 44975, 0}
        set ANSI bright white color to {53456, 53456, 53456}
    end tell
end tell
