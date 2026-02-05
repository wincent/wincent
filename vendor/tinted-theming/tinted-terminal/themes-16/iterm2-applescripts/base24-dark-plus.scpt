(*
    base24 Dark Plus
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3598, 3598, 3598}
        set foreground color to {50629, 50629, 50629}

        -- Set ANSI Colors
        set ANSI black color to {3598, 3598, 3598}
        set ANSI red color to {52685, 12593, 12593}
        set ANSI green color to {3341, 48316, 31097}
        set ANSI yellow color to {15163, 36494, 60138}
        set ANSI blue color to {9252, 29298, 51400}
        set ANSI magenta color to {48316, 16191, 48316}
        set ANSI cyan color to {4369, 43176, 52685}
        set ANSI white color to {50629, 50629, 50629}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {34181, 34181, 34181}
        set ANSI bright red color to {61937, 19532, 19532}
        set ANSI bright green color to {8995, 53713, 35723}
        set ANSI bright yellow color to {62965, 62965, 17219}
        set ANSI bright blue color to {15163, 36494, 60138}
        set ANSI bright magenta color to {54998, 28784, 54998}
        set ANSI bright cyan color to {10537, 47288, 56283}
        set ANSI bright white color to {58853, 58853, 58853}
    end tell
end tell
