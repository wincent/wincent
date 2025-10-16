(*
    base24 Unikitty
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 35980, 55769}
        set foreground color to {47545, 45489, 47288}

        -- Set ANSI Colors
        set ANSI black color to {3084, 3084, 3084}
        set ANSI red color to {43176, 3855, 8224}
        set ANSI green color to {47802, 64764, 35723}
        set ANSI yellow color to {0, 29812, 60138}
        set ANSI blue color to {5140, 24415, 52685}
        set ANSI magenta color to {65535, 13878, 41634}
        set ANSI cyan color to {27499, 53456, 48316}
        set ANSI white color to {57825, 54998, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16962, 16962, 16962}
        set ANSI bright red color to {55512, 4883, 10537}
        set ANSI bright green color to {53970, 65535, 44975}
        set ANSI bright yellow color to {65535, 61166, 20560}
        set ANSI bright blue color to {0, 29812, 60138}
        set ANSI bright magenta color to {65021, 54741, 58853}
        set ANSI bright cyan color to {31097, 60395, 54741}
        set ANSI bright white color to {65535, 62194, 65021}
    end tell
end tell
