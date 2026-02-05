(*
    base16 Tokyo Night Terminal Dark
    Scheme author: Michaël Ball
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 5654, 7710}
        set foreground color to {30840, 31868, 39321}

        -- Set ANSI Colors
        set ANSI black color to {5654, 5654, 7710}
        set ANSI red color to {63479, 30326, 36494}
        set ANSI green color to {16705, 42662, 46517}
        set ANSI yellow color to {57568, 44975, 26728}
        set ANSI blue color to {31354, 41634, 63479}
        set ANSI magenta color to {48059, 39578, 63479}
        set ANSI cyan color to {32125, 53199, 65535}
        set ANSI white color to {30840, 31868, 39321}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17476, 19275, 27242}
        set ANSI bright red color to {63479, 30326, 36494}
        set ANSI bright green color to {16705, 42662, 46517}
        set ANSI bright yellow color to {57568, 44975, 26728}
        set ANSI bright blue color to {31354, 41634, 63479}
        set ANSI bright magenta color to {48059, 39578, 63479}
        set ANSI bright cyan color to {32125, 53199, 65535}
        set ANSI bright white color to {54741, 54998, 56283}
    end tell
end tell
