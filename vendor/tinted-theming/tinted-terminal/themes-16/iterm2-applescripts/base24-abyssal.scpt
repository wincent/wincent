(*
    base24 Abyssal
    Scheme author: Joss Wright (https://www.weirddatascience.net)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {57568, 58596, 59367}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 30069, 6168}
        set ANSI green color to {14649, 43690, 25186}
        set ANSI yellow color to {65535, 52428, 0}
        set ANSI blue color to {257, 41120, 58596}
        set ANSI magenta color to {43947, 23644, 52171}
        set ANSI cyan color to {16448, 57568, 53456}
        set ANSI white color to {57568, 58596, 59367}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20303, 23387, 26214}
        set ANSI bright red color to {65278, 44204, 22359}
        set ANSI bright green color to {19532, 57568, 28784}
        set ANSI bright yellow color to {65535, 61166, 20560}
        set ANSI bright blue color to {19275, 38807, 51400}
        set ANSI bright magenta color to {47802, 36494, 64250}
        set ANSI bright cyan color to {8224, 45746, 43690}
        set ANSI bright white color to {63479, 63479, 65535}
    end tell
end tell
