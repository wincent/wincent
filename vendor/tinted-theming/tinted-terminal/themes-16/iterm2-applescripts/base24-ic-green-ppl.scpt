(*
    base24 IC-Green-PPL
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11308, 11308, 11308}
        set foreground color to {44461, 54741, 46774}

        -- Set ANSI Colors
        set ANSI black color to {11308, 11308, 11308}
        set ANSI red color to {65278, 9766, 13621}
        set ANSI green color to {16705, 42662, 14392}
        set ANSI yellow color to {11822, 64250, 60395}
        set ANSI blue color to {11822, 50115, 47545}
        set ANSI magenta color to {20560, 41120, 38550}
        set ANSI cyan color to {15420, 41120, 30840}
        set ANSI white color to {44461, 54741, 46774}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15163, 33924, 15934}
        set ANSI bright red color to {46260, 64250, 23644}
        set ANSI bright green color to {44718, 64250, 34438}
        set ANSI bright yellow color to {56026, 64250, 34695}
        set ANSI bright blue color to {11822, 64250, 60395}
        set ANSI bright magenta color to {20560, 64250, 64250}
        set ANSI bright cyan color to {15420, 64250, 51400}
        set ANSI bright white color to {57568, 61937, 56540}
    end tell
end tell
