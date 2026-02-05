(*
    base16 Nord Light
    Scheme author: threddast, based on fuxialexander&#39;s doom-nord-light-theme (Doom Emacs)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {58853, 59881, 61680}
        set foreground color to {11822, 13364, 16448}

        -- Set ANSI Colors
        set ANSI black color to {58853, 59881, 61680}
        set ANSI red color to {39321, 12850, 19275}
        set ANSI green color to {20303, 35209, 19532}
        set ANSI yellow color to {39578, 30069, 0}
        set ANSI blue color to {15163, 28270, 43176}
        set ANSI magenta color to {38807, 13878, 23387}
        set ANSI cyan color to {14649, 36494, 44204}
        set ANSI white color to {11822, 13364, 16448}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {44718, 47802, 53199}
        set ANSI bright red color to {39321, 12850, 19275}
        set ANSI bright green color to {20303, 35209, 19532}
        set ANSI bright yellow color to {39578, 30069, 0}
        set ANSI bright blue color to {15163, 28270, 43176}
        set ANSI bright magenta color to {38807, 13878, 23387}
        set ANSI bright cyan color to {14649, 36494, 44204}
        set ANSI bright white color to {10537, 33667, 36237}
    end tell
end tell
