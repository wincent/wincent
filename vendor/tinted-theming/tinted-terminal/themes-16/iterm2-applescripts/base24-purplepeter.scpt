(*
    base24 Purplepeter
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10794, 6682, 19018}
        set foreground color to {50115, 36494, 26985}

        -- Set ANSI Colors
        set ANSI black color to {10794, 6682, 19018}
        set ANSI red color to {65535, 30840, 27756}
        set ANSI green color to {39064, 46260, 33153}
        set ANSI yellow color to {31097, 56026, 60909}
        set ANSI blue color to {26214, 55769, 61423}
        set ANSI magenta color to {59110, 36494, 52685}
        set ANSI cyan color to {47545, 35980, 65535}
        set ANSI white color to {50115, 36494, 26985}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {19275, 13878, 14649}
        set ANSI bright red color to {63736, 40863, 37522}
        set ANSI bright green color to {46260, 48573, 36494}
        set ANSI bright yellow color to {61937, 59881, 49087}
        set ANSI bright blue color to {31097, 56026, 60909}
        set ANSI bright magenta color to {47545, 37265, 54484}
        set ANSI bright cyan color to {41120, 41120, 54998}
        set ANSI bright white color to {47545, 44718, 54227}
    end tell
end tell
