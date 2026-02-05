(*
    base24 Operator Mono Dark
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 6425, 6425}
        set foreground color to {49344, 50372, 49344}

        -- Set ANSI Colors
        set ANSI black color to {6425, 6425, 6425}
        set ANSI red color to {51914, 14135, 11565}
        set ANSI green color to {19789, 31611, 14906}
        set ANSI yellow color to {35209, 54227, 63222}
        set ANSI blue color to {17219, 34695, 53199}
        set ANSI magenta color to {47288, 27756, 46260}
        set ANSI cyan color to {29298, 54484, 50886}
        set ANSI white color to {49344, 50372, 49344}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {42662, 43176, 42662}
        set ANSI bright red color to {50115, 32125, 25186}
        set ANSI bright green color to {33667, 53456, 41634}
        set ANSI bright yellow color to {65021, 65021, 50629}
        set ANSI bright blue color to {35209, 54227, 63222}
        set ANSI bright magenta color to {65278, 11308, 31097}
        set ANSI bright cyan color to {33410, 59881, 56026}
        set ANSI bright white color to {65021, 65021, 63222}
    end tell
end tell
