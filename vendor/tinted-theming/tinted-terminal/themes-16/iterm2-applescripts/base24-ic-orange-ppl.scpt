(*
    base24 IC-Orange-PPL
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 9766, 9766}
        set foreground color to {55769, 43433, 29041}

        -- Set ANSI Colors
        set ANSI black color to {9766, 9766, 9766}
        set ANSI red color to {49344, 14649, 0}
        set ANSI green color to {41891, 43433, 0}
        set ANSI yellow color to {65535, 48573, 21588}
        set ANSI blue color to {48573, 27756, 0}
        set ANSI magenta color to {64507, 23901, 0}
        set ANSI cyan color to {63479, 38036, 0}
        set ANSI white color to {55769, 43433, 29041}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {36751, 27756, 16705}
        set ANSI bright red color to {65535, 35723, 26471}
        set ANSI bright green color to {63222, 65535, 16191}
        set ANSI bright yellow color to {65535, 58339, 28270}
        set ANSI bright blue color to {65535, 48573, 21588}
        set ANSI bright magenta color to {64764, 34695, 20303}
        set ANSI bright cyan color to {50629, 38807, 21074}
        set ANSI bright white color to {63993, 63993, 65278}
    end tell
end tell
