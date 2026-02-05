(*
    base24 Nocturnal Winter
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 3341, 5911}
        set foreground color to {56540, 56540, 56540}

        -- Set ANSI Colors
        set ANSI black color to {3341, 3341, 5911}
        set ANSI red color to {61937, 11565, 21074}
        set ANSI green color to {2056, 52685, 32125}
        set ANSI yellow color to {24672, 38293, 65278}
        set ANSI blue color to {12336, 33153, 57311}
        set ANSI magenta color to {65278, 10794, 27756}
        set ANSI cyan color to {2313, 51400, 31354}
        set ANSI white color to {56540, 56540, 56540}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {40606, 40606, 40606}
        set ANSI bright red color to {61937, 27756, 34181}
        set ANSI bright green color to {2570, 59367, 36237}
        set ANSI bright yellow color to {65278, 64507, 26471}
        set ANSI bright blue color to {24672, 38293, 65278}
        set ANSI bright magenta color to {65535, 30840, 41634}
        set ANSI bright cyan color to {2570, 59367, 36237}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
