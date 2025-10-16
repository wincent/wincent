(*
    base24 deep
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2056, 2056, 2056}
        set foreground color to {48316, 48316, 48316}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {54998, 0, 1285}
        set ANSI green color to {7196, 55512, 5397}
        set ANSI yellow color to {40863, 43176, 65278}
        set ANSI blue color to {22102, 25957, 65278}
        set ANSI magenta color to {44975, 20817, 55769}
        set ANSI cyan color to {20303, 53970, 55769}
        set ANSI white color to {57311, 57311, 57311}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21331, 21331, 21331}
        set ANSI bright red color to {64507, 0, 1542}
        set ANSI bright green color to {8481, 65278, 5911}
        set ANSI bright yellow color to {65278, 56540, 11051}
        set ANSI bright blue color to {40863, 43176, 65278}
        set ANSI bright magenta color to {57568, 39321, 65278}
        set ANSI bright cyan color to {35980, 63993, 65278}
        set ANSI bright white color to {65535, 65278, 65278}
    end tell
end tell
