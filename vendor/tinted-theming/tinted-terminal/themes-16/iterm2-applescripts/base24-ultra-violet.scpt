(*
    base24 Ultra Violet
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 10023, 10280}
        set foreground color to {49601, 49858, 49858}

        -- Set ANSI Colors
        set ANSI black color to {8995, 9766, 10280}
        set ANSI red color to {65535, 0, 37008}
        set ANSI green color to {46517, 65535, 0}
        set ANSI yellow color to {32639, 60395, 65535}
        set ANSI blue color to {18247, 57311, 64507}
        set ANSI magenta color to {54998, 12336, 65535}
        set ANSI cyan color to {3598, 65535, 48059}
        set ANSI white color to {57825, 57825, 57825}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25186, 25957, 26214}
        set ANSI bright red color to {64507, 22359, 46260}
        set ANSI bright green color to {57054, 65535, 35723}
        set ANSI bright yellow color to {60395, 57311, 34438}
        set ANSI bright blue color to {32639, 60395, 65535}
        set ANSI bright magenta color to {59110, 33153, 65535}
        set ANSI bright cyan color to {26728, 64764, 53970}
        set ANSI bright white color to {63993, 63993, 62708}
    end tell
end tell
