(*
    base24 Forest Blue
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {1285, 5397, 6425}
        set foreground color to {47288, 45489, 43433}

        -- Set ANSI Colors
        set ANSI black color to {1285, 5397, 6425}
        set ANSI red color to {63736, 33153, 36494}
        set ANSI green color to {37522, 54227, 41634}
        set ANSI yellow color to {14649, 42919, 41634}
        set ANSI blue color to {36494, 53456, 52942}
        set ANSI magenta color to {24158, 17990, 35980}
        set ANSI cyan color to {12593, 25957, 35980}
        set ANSI white color to {47288, 45489, 43433}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 25443, 24929}
        set ANSI bright red color to {64507, 15677, 26214}
        set ANSI bright green color to {27499, 46260, 36237}
        set ANSI bright yellow color to {12079, 51400, 22873}
        set ANSI bright blue color to {14649, 42919, 41634}
        set ANSI bright magenta color to {32382, 25186, 46003}
        set ANSI bright cyan color to {24672, 38550, 49087}
        set ANSI bright white color to {58082, 55512, 52685}
    end tell
end tell
