(*
    base24 One Half Light
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64250, 64250, 64250}
        set foreground color to {53199, 53456, 53970}

        -- Set ANSI Colors
        set ANSI black color to {14135, 14649, 16962}
        set ANSI red color to {58596, 22102, 18761}
        set ANSI green color to {20303, 41377, 20303}
        set ANSI yellow color to {24929, 44975, 61423}
        set ANSI blue color to {0, 33924, 48316}
        set ANSI magenta color to {42662, 9509, 42148}
        set ANSI cyan color to {2313, 38550, 46003}
        set ANSI white color to {64250, 64250, 64250}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20303, 21074, 23901}
        set ANSI bright red color to {57311, 27756, 30069}
        set ANSI bright green color to {39064, 50115, 31097}
        set ANSI bright yellow color to {58596, 49344, 31354}
        set ANSI bright blue color to {24929, 44975, 61423}
        set ANSI bright magenta color to {50629, 30583, 56797}
        set ANSI bright cyan color to {22102, 46517, 49601}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
