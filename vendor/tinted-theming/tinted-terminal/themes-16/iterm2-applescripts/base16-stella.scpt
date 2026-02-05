(*
    base16 Stella
    Scheme author: Shrimpram
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11051, 8481, 15420}
        set foreground color to {39321, 35723, 44461}

        -- Set ANSI Colors
        set ANSI black color to {11051, 8481, 15420}
        set ANSI red color to {51143, 39321, 34695}
        set ANSI green color to {44204, 51143, 39835}
        set ANSI yellow color to {51143, 50886, 37265}
        set ANSI blue color to {42405, 43690, 54484}
        set ANSI magenta color to {50629, 38036, 65535}
        set ANSI cyan color to {39835, 51143, 49087}
        set ANSI white color to {39321, 35723, 44461}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25957, 22873, 30840}
        set ANSI bright red color to {51143, 39321, 34695}
        set ANSI bright green color to {44204, 51143, 39835}
        set ANSI bright yellow color to {51143, 50886, 37265}
        set ANSI bright blue color to {42405, 43690, 54484}
        set ANSI bright magenta color to {50629, 38036, 65535}
        set ANSI bright cyan color to {39835, 51143, 49087}
        set ANSI bright white color to {60395, 56540, 65535}
    end tell
end tell
