(*
    base24 Later This Evening
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8481, 8481}
        set foreground color to {15934, 16191, 16191}

        -- Set ANSI Colors
        set ANSI black color to {11051, 11051, 11051}
        set ANSI red color to {54227, 23130, 24415}
        set ANSI green color to {44975, 47802, 26214}
        set ANSI yellow color to {25957, 39321, 54741}
        set ANSI blue color to {41120, 47545, 54741}
        set ANSI magenta color to {49087, 37522, 54741}
        set ANSI cyan color to {37265, 48830, 46774}
        set ANSI white color to {15163, 15420, 15420}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17476, 18247, 18247}
        set ANSI bright red color to {54227, 8738, 11822}
        set ANSI bright green color to {43690, 48059, 14649}
        set ANSI bright yellow color to {58596, 48573, 14649}
        set ANSI bright blue color to {25957, 39321, 54741}
        set ANSI bright magenta color to {43690, 21074, 54741}
        set ANSI bright cyan color to {24415, 49087, 44461}
        set ANSI bright white color to {49344, 49858, 49858}
    end tell
end tell
