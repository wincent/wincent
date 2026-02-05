(*
    base24 Sleepy Hollow
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4626, 4626, 4883}
        set foreground color to {38550, 34438, 33924}

        -- Set ANSI Colors
        set ANSI black color to {4626, 4626, 4883}
        set ANSI red color to {47545, 14649, 13364}
        set ANSI green color to {37008, 30583, 15934}
        set ANSI yellow color to {32896, 34181, 61423}
        set ANSI blue color to {24158, 25186, 46260}
        set ANSI magenta color to {41120, 31868, 31611}
        set ANSI cyan color to {36494, 44718, 43433}
        set ANSI white color to {38550, 34438, 33924}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 24158, 27756}
        set ANSI bright red color to {55769, 17476, 15934}
        set ANSI bright green color to {54998, 45232, 20046}
        set ANSI bright yellow color to {63222, 26471, 4883}
        set ANSI bright blue color to {32896, 34181, 61423}
        set ANSI bright magenta color to {57825, 49858, 47802}
        set ANSI bright cyan color to {42148, 56283, 59367}
        set ANSI bright white color to {53713, 51143, 43433}
    end tell
end tell
