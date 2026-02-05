(*
    base16 Gotham
    Scheme author: Andrea Leopardi (arranged by Brett Jones)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3084, 4112, 5140}
        set foreground color to {22873, 40092, 43947}

        -- Set ANSI Colors
        set ANSI black color to {3084, 4112, 5140}
        set ANSI red color to {49858, 12593, 10023}
        set ANSI green color to {13107, 34181, 40606}
        set ANSI yellow color to {60909, 46260, 17219}
        set ANSI blue color to {6425, 21588, 26214}
        set ANSI magenta color to {34952, 35980, 42662}
        set ANSI cyan color to {10794, 43176, 35209}
        set ANSI white color to {22873, 40092, 43947}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {2570, 14135, 18761}
        set ANSI bright red color to {49858, 12593, 10023}
        set ANSI bright green color to {13107, 34181, 40606}
        set ANSI bright yellow color to {60909, 46260, 17219}
        set ANSI bright blue color to {6425, 21588, 26214}
        set ANSI bright magenta color to {34952, 35980, 42662}
        set ANSI bright cyan color to {10794, 43176, 35209}
        set ANSI bright white color to {54227, 60395, 59881}
    end tell
end tell
