(*
    base16 Everforest Light (Medium)
    Scheme author: Márcio Sobel (https://github.com/marciosobel)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65021, 63222, 58339}
        set foreground color to {23644, 27242, 29298}

        -- Set ANSI Colors
        set ANSI black color to {65021, 63222, 58339}
        set ANSI red color to {63736, 21845, 21074}
        set ANSI green color to {36237, 41377, 257}
        set ANSI yellow color to {57311, 41120, 0}
        set ANSI blue color to {14906, 38036, 50629}
        set ANSI magenta color to {57311, 26985, 47802}
        set ANSI cyan color to {13621, 42919, 31868}
        set ANSI white color to {23644, 27242, 29298}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {37779, 40863, 37265}
        set ANSI bright red color to {63736, 21845, 21074}
        set ANSI bright green color to {36237, 41377, 257}
        set ANSI bright yellow color to {57311, 41120, 0}
        set ANSI bright blue color to {14906, 38036, 50629}
        set ANSI bright magenta color to {57311, 26985, 47802}
        set ANSI bright cyan color to {13621, 42919, 31868}
        set ANSI bright white color to {11565, 13621, 15163}
    end tell
end tell
