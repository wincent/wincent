(*
    base24 The Hulk
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 7453, 7710}
        set foreground color to {46774, 46774, 45489}

        -- Set ANSI Colors
        set ANSI black color to {6939, 7453, 7710}
        set ANSI red color to {9509, 40349, 6682}
        set ANSI green color to {4883, 52942, 12079}
        set ANSI yellow color to {20303, 27242, 38293}
        set ANSI blue color to {9252, 9252, 62708}
        set ANSI magenta color to {25700, 7710, 29555}
        set ANSI cyan color to {14135, 35980, 43433}
        set ANSI white color to {46774, 46774, 45489}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29298, 29812, 29555}
        set ANSI bright red color to {36237, 65535, 10794}
        set ANSI bright green color to {18504, 65535, 30326}
        set ANSI bright yellow color to {14906, 65278, 5397}
        set ANSI bright blue color to {20303, 27242, 38293}
        set ANSI bright magenta color to {29298, 22359, 40349}
        set ANSI bright cyan color to {16191, 34181, 42405}
        set ANSI bright white color to {58853, 58853, 57568}
    end tell
end tell
