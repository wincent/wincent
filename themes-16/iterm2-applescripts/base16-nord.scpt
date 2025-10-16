(*
    base16 Nord
    Scheme author: arcticicestudio
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11822, 13364, 16448}
        set foreground color to {58853, 59881, 61680}

        -- Set ANSI Colors
        set ANSI black color to {15163, 16962, 21074}
        set ANSI red color to {49087, 24929, 27242}
        set ANSI green color to {41891, 48830, 35980}
        set ANSI yellow color to {60395, 52171, 35723}
        set ANSI blue color to {33153, 41377, 49601}
        set ANSI magenta color to {46260, 36494, 44461}
        set ANSI cyan color to {34952, 49344, 53456}
        set ANSI white color to {60652, 61423, 62708}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17219, 19532, 24158}
        set ANSI bright red color to {49087, 24929, 27242}
        set ANSI bright green color to {41891, 48830, 35980}
        set ANSI bright yellow color to {60395, 52171, 35723}
        set ANSI bright blue color to {33153, 41377, 49601}
        set ANSI bright magenta color to {46260, 36494, 44461}
        set ANSI bright cyan color to {34952, 49344, 53456}
        set ANSI bright white color to {36751, 48316, 48059}
    end tell
end tell
