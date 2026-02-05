(*
    base24 Rippedcasts
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11051, 11051, 11051}
        set foreground color to {43176, 43176, 43176}

        -- Set ANSI Colors
        set ANSI black color to {11051, 11051, 11051}
        set ANSI red color to {52685, 44975, 38293}
        set ANSI green color to {42919, 65535, 24672}
        set ANSI yellow color to {34438, 48573, 51657}
        set ANSI blue color to {30069, 42405, 45232}
        set ANSI magenta color to {65535, 29555, 65021}
        set ANSI cyan color to {22873, 25700, 32382}
        set ANSI white color to {43176, 43176, 43176}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31868, 31868, 31868}
        set ANSI bright red color to {61166, 52171, 44461}
        set ANSI bright green color to {48316, 61166, 26728}
        set ANSI bright yellow color to {58853, 58853, 0}
        set ANSI bright blue color to {34438, 48573, 51657}
        set ANSI bright magenta color to {58853, 0, 58853}
        set ANSI bright cyan color to {35980, 39835, 50115}
        set ANSI bright white color to {58853, 58853, 58853}
    end tell
end tell
