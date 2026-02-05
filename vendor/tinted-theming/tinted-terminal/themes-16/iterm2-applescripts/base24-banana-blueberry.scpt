(*
    base24 Banana Blueberry
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 4883, 8738}
        set foreground color to {50886, 51657, 52685}

        -- Set ANSI Colors
        set ANSI black color to {6425, 4883, 8738}
        set ANSI red color to {65535, 27242, 32382}
        set ANSI green color to {0, 48316, 39835}
        set ANSI yellow color to {37265, 65535, 62451}
        set ANSI blue color to {8738, 59624, 57311}
        set ANSI magenta color to {56540, 14649, 26985}
        set ANSI cyan color to {21845, 46774, 49601}
        set ANSI white color to {50886, 51657, 52685}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29298, 31097, 34181}
        set ANSI bright red color to {65021, 40606, 41377}
        set ANSI bright green color to {38807, 50115, 30840}
        set ANSI bright yellow color to {63993, 58596, 27242}
        set ANSI bright blue color to {37265, 65535, 62451}
        set ANSI bright magenta color to {56026, 28784, 54741}
        set ANSI bright cyan color to {48316, 62194, 65278}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
