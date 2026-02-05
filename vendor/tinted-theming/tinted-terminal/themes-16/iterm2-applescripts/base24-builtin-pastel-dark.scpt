(*
    base24 Builtin Pastel Dark
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {53713, 53713, 53713}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 27499, 24672}
        set ANSI green color to {42919, 65535, 24672}
        set ANSI yellow color to {46517, 56540, 65278}
        set ANSI blue color to {38550, 51914, 65021}
        set ANSI magenta color to {65535, 29555, 65021}
        set ANSI cyan color to {50886, 50372, 65021}
        set ANSI white color to {53713, 53713, 53713}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {39064, 39064, 39064}
        set ANSI bright red color to {65535, 46774, 45232}
        set ANSI bright green color to {52942, 65535, 43947}
        set ANSI bright yellow color to {65535, 65535, 52171}
        set ANSI bright blue color to {46517, 56540, 65278}
        set ANSI bright magenta color to {65535, 40092, 65278}
        set ANSI bright cyan color to {57311, 57311, 65278}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
