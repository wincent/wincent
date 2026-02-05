(*
    base16 XCode Dusk
    Scheme author: Elsa Gonsiorowski (https://github.com/gonsie)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 11051, 13621}
        set foreground color to {37779, 38293, 39321}

        -- Set ANSI Colors
        set ANSI black color to {10280, 11051, 13621}
        set ANSI red color to {45746, 6168, 35209}
        set ANSI green color to {57311, 0, 514}
        set ANSI yellow color to {17219, 33410, 34952}
        set ANSI blue color to {31097, 3598, 44461}
        set ANSI magenta color to {45746, 6168, 35209}
        set ANSI cyan color to {0, 41120, 48830}
        set ANSI white color to {37779, 38293, 39321}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26728, 27242, 29041}
        set ANSI bright red color to {45746, 6168, 35209}
        set ANSI bright green color to {57311, 0, 514}
        set ANSI bright yellow color to {17219, 33410, 34952}
        set ANSI bright blue color to {31097, 3598, 44461}
        set ANSI bright magenta color to {45746, 6168, 35209}
        set ANSI bright cyan color to {0, 41120, 48830}
        set ANSI bright white color to {48830, 49087, 49858}
    end tell
end tell
