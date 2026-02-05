(*
    base24 Thayer Bright
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6939, 7453, 7710}
        set foreground color to {44461, 44461, 43433}

        -- Set ANSI Colors
        set ANSI black color to {6939, 7453, 7710}
        set ANSI red color to {63993, 9766, 29298}
        set ANSI green color to {19789, 63479, 16448}
        set ANSI yellow color to {16191, 30840, 65535}
        set ANSI blue color to {9766, 22102, 54998}
        set ANSI magenta color to {35980, 21588, 65278}
        set ANSI cyan color to {14135, 51400, 46260}
        set ANSI white color to {44461, 44461, 43433}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28527, 29041, 28784}
        set ANSI bright red color to {65535, 22873, 38293}
        set ANSI bright green color to {46774, 58339, 21588}
        set ANSI bright yellow color to {65278, 60909, 27756}
        set ANSI bright blue color to {16191, 30840, 65535}
        set ANSI bright magenta color to {40606, 28527, 65278}
        set ANSI bright cyan color to {8995, 52942, 54484}
        set ANSI bright white color to {63736, 63736, 62194}
    end tell
end tell
