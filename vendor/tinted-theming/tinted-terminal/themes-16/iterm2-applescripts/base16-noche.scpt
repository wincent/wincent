(*
    base16 Noche
    Scheme author: Teshre
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3084, 3598, 5654}
        set foreground color to {52171, 54484, 60652}

        -- Set ANSI Colors
        set ANSI black color to {3084, 3598, 5654}
        set ANSI red color to {58082, 29298, 32382}
        set ANSI green color to {31868, 50629, 38550}
        set ANSI yellow color to {55512, 49344, 25186}
        set ANSI blue color to {31354, 41120, 59624}
        set ANSI magenta color to {47031, 39578, 57568}
        set ANSI cyan color to {28013, 55512, 53456}
        set ANSI white color to {52171, 54484, 60652}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23130, 24929, 30840}
        set ANSI bright red color to {58082, 29298, 32382}
        set ANSI bright green color to {31868, 50629, 38550}
        set ANSI bright yellow color to {55512, 49344, 25186}
        set ANSI bright blue color to {31354, 41120, 59624}
        set ANSI bright magenta color to {47031, 39578, 57568}
        set ANSI bright cyan color to {28013, 55512, 53456}
        set ANSI bright white color to {59110, 60652, 64250}
    end tell
end tell
