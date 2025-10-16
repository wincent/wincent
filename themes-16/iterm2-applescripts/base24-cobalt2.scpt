(*
    base24 Cobalt2
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4626, 9766, 14135}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 0, 0}
        set ANSI green color to {14135, 56797, 8481}
        set ANSI yellow color to {21845, 21845, 65535}
        set ANSI blue color to {5140, 24672, 53970}
        set ANSI magenta color to {65535, 0, 23901}
        set ANSI cyan color to {0, 48059, 48059}
        set ANSI white color to {48059, 48059, 48059}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {62708, 3341, 5911}
        set ANSI bright green color to {15163, 53199, 7453}
        set ANSI bright yellow color to {60652, 51400, 2313}
        set ANSI bright blue color to {21845, 21845, 65535}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {27242, 58339, 63993}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
