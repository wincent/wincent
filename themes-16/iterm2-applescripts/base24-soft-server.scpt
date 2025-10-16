(*
    base24 Soft Server
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 9766, 9766}
        set foreground color to {35980, 38293, 38036}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {41377, 26728, 26985}
        set ANSI green color to {39321, 42405, 26985}
        set ANSI yellow color to {25186, 45489, 57311}
        set ANSI blue color to {27242, 36751, 41891}
        set ANSI magenta color to {26985, 29041, 41891}
        set ANSI cyan color to {27499, 42148, 36751}
        set ANSI white color to {39321, 41891, 41634}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 27756, 27499}
        set ANSI bright red color to {56540, 23387, 24415}
        set ANSI bright green color to {49087, 57054, 21588}
        set ANSI bright yellow color to {57054, 46003, 24415}
        set ANSI bright blue color to {25186, 45489, 57311}
        set ANSI bright magenta color to {24415, 28270, 57054}
        set ANSI bright cyan color to {25700, 58339, 40092}
        set ANSI bright white color to {53713, 57311, 57054}
    end tell
end tell
