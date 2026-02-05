(*
    base16 Macintosh
    Scheme author: Rebecca Bettencourt (http://www.kreativekorp.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {49344, 49344, 49344}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {56797, 2313, 1799}
        set ANSI green color to {7967, 47031, 5140}
        set ANSI yellow color to {64507, 62451, 1285}
        set ANSI blue color to {0, 0, 54227}
        set ANSI magenta color to {18247, 0, 42405}
        set ANSI cyan color to {514, 43947, 60138}
        set ANSI white color to {49344, 49344, 49344}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32896, 32896, 32896}
        set ANSI bright red color to {56797, 2313, 1799}
        set ANSI bright green color to {7967, 47031, 5140}
        set ANSI bright yellow color to {64507, 62451, 1285}
        set ANSI bright blue color to {0, 0, 54227}
        set ANSI bright magenta color to {18247, 0, 42405}
        set ANSI bright cyan color to {514, 43947, 60138}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
