(*
    base24 Under The Sea
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 4112, 5397}
        set foreground color to {15677, 20560, 21331}

        -- Set ANSI Colors
        set ANSI black color to {514, 8224, 9766}
        set ANSI red color to {45489, 12079, 11308}
        set ANSI green color to {0, 43433, 16448}
        set ANSI yellow color to {24929, 54484, 47545}
        set ANSI blue color to {17476, 39321, 34181}
        set ANSI magenta color to {0, 22873, 40092}
        set ANSI cyan color to {23644, 32382, 6425}
        set ANSI white color to {16448, 21845, 21588}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14135, 17219, 20560}
        set ANSI bright red color to {65535, 16962, 16962}
        set ANSI bright green color to {10794, 60138, 24158}
        set ANSI bright yellow color to {36237, 54227, 65021}
        set ANSI bright blue color to {24929, 54484, 47545}
        set ANSI bright magenta color to {4626, 39064, 65535}
        set ANSI bright cyan color to {39064, 53199, 10280}
        set ANSI bright white color to {22616, 64250, 54998}
    end tell
end tell
